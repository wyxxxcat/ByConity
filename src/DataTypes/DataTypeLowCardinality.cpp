/*
 * Copyright 2016-2023 ClickHouse, Inc.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */


/*
 * This file may have been modified by Bytedance Ltd. and/or its affiliates (“ Bytedance's Modifications”).
 * All Bytedance's Modifications are Copyright (2023) Bytedance Ltd. and/or its affiliates.
 */

#include <Columns/ColumnFixedString.h>
#include <Columns/ColumnLowCardinality.h>
#include <Columns/ColumnUnique.h>
#include <Columns/ColumnsCommon.h>
#include <common/TypeLists.h>
#include <Common/HashTable/HashMap.h>
#include <Common/assert_cast.h>
#include <Common/typeid_cast.h>
#include <Core/Field.h>
#include <DataTypes/DataTypeDate.h>
#include <DataTypes/DataTypeDateTime.h>
#include <DataTypes/DataTypeFactory.h>
#include <DataTypes/DataTypeInterval.h>
#include <DataTypes/DataTypeLowCardinality.h>
#include <DataTypes/DataTypeNullable.h>
#include <DataTypes/DataTypesNumber.h>
#include <DataTypes/Serializations/SerializationLowCardinality.h>
#include <Parsers/IAST.h>

namespace DB
{

namespace ErrorCodes
{
    extern const int NUMBER_OF_ARGUMENTS_DOESNT_MATCH;
    extern const int LOGICAL_ERROR;
    extern const int ILLEGAL_TYPE_OF_ARGUMENT;
}

DataTypeLowCardinality::DataTypeLowCardinality(DataTypePtr dictionary_type_)
        : dictionary_type(std::move(dictionary_type_))
{
    auto inner_type = dictionary_type;
    if (dictionary_type->isNullable())
        inner_type = static_cast<const DataTypeNullable &>(*dictionary_type).getNestedType();

    if (!inner_type->canBeInsideLowCardinality())
        throw Exception("DataTypeLowCardinality is supported only for numbers, strings, Date or DateTime, but got "
                        + dictionary_type->getName(), ErrorCodes::ILLEGAL_TYPE_OF_ARGUMENT);
}

namespace
{
    template <typename Creator>
    struct CreateColumnVector
    {
        MutableColumnUniquePtr & column;
        const IDataType & keys_type;
        const Creator & creator;

        CreateColumnVector(MutableColumnUniquePtr & column_, const IDataType & keys_type_, const Creator & creator_)
                : column(column_), keys_type(keys_type_), creator(creator_)
        {
        }

        template <typename T>
        void operator()(TypeList<T>)
        {
            if (typeid_cast<const DataTypeNumber<T> *>(&keys_type))
                column = creator(static_cast<ColumnVector<T> *>(nullptr));
        }
    };
}

template <typename Creator>
MutableColumnUniquePtr DataTypeLowCardinality::createColumnUniqueImpl(const IDataType & keys_type,
                                                                      const Creator & creator)
{
    const auto * type = &keys_type;
    if (const auto * nullable_type = typeid_cast<const DataTypeNullable *>(&keys_type))
        type = nullable_type->getNestedType().get();

    WhichDataType which(type);

    if (which.isString())
        return creator(static_cast<ColumnString *>(nullptr));
    else if (which.isFixedString())
        return creator(static_cast<ColumnFixedString *>(nullptr));
    else if (which.isDate())
        return creator(static_cast<ColumnVector<UInt16> *>(nullptr));
    else if (which.isDate32())
        return creator(static_cast<ColumnVector<Int32> *>(nullptr));
    else if (which.isDateTime())
        return creator(static_cast<ColumnVector<UInt32> *>(nullptr));
    else if (which.isUUID())
        return creator(static_cast<ColumnVector<UUID> *>(nullptr));
    else if (which.isIPv4())
        return creator(static_cast<ColumnVector<IPv4> *>(nullptr));
    else if (which.isIPv6())
        return creator(static_cast<ColumnVector<IPv6> *>(nullptr));
    else if (which.isInterval())
        return creator(static_cast<DataTypeInterval::ColumnType *>(nullptr));
    else if (which.isInt() || which.isUInt() || which.isFloat())
    {
        MutableColumnUniquePtr column;
        TypeListUtils::forEach(TypeListIntAndFloat{}, CreateColumnVector(column, *type, creator));

        if (!column)
            throw Exception("Unexpected numeric type: " + type->getName(), ErrorCodes::LOGICAL_ERROR);

        return column;
    }

    throw Exception("Unexpected dictionary type for DataTypeLowCardinality: " + type->getName(),
                    ErrorCodes::LOGICAL_ERROR);
}


MutableColumnUniquePtr DataTypeLowCardinality::createColumnUnique(const IDataType & keys_type)
{
    auto creator = [&](auto x)
    {
        using ColumnType = typename std::remove_pointer<decltype(x)>::type;
        return ColumnUnique<ColumnType>::create(keys_type);
    };
    return createColumnUniqueImpl(keys_type, creator);
}

MutableColumnUniquePtr DataTypeLowCardinality::createColumnUnique(const IDataType & keys_type, MutableColumnPtr && keys)
{
    auto creator = [&](auto x)
    {
        using ColumnType = typename std::remove_pointer<decltype(x)>::type;
        return ColumnUnique<ColumnType>::create(std::move(keys), keys_type.isNullable());
    };
    return createColumnUniqueImpl(keys_type, creator);
}

bool DataTypeLowCardinality::canBeByteMapValueType() const
{
    if (const auto * nullable_type = typeid_cast<const DataTypeNullable *>(dictionary_type.get()))
        return nullable_type->getNestedType()->canBeByteMapValueType();
    return false;
}

Field DataTypeLowCardinality::stringToVisitorField(const String & ins) const
{
    return dictionary_type->stringToVisitorField(ins);
}

String DataTypeLowCardinality::stringToVisitorString(const String & ins) const
{
    return dictionary_type->stringToVisitorString(ins);
}

MutableColumnPtr DataTypeLowCardinality::createColumn() const
{
    MutableColumnPtr indexes = DataTypeUInt8().createColumn();
    MutableColumnPtr dictionary = createColumnUnique(*dictionary_type);
    return ColumnLowCardinality::create(std::move(dictionary), std::move(indexes));
}

Field DataTypeLowCardinality::getDefault() const
{
    return dictionary_type->getDefault();
}

bool DataTypeLowCardinality::equals(const IDataType & rhs) const
{
    auto const *type_lc = typeid_cast<const DataTypeLowCardinality *>(&rhs);
    if (type_lc)
        return dictionary_type->equals(*type_lc->getDictionaryType());
    auto const *type_full_lc = typeid_cast<const DataTypeFullLowCardinality *>(&rhs);
    if (type_full_lc)
        return dictionary_type->equals(*type_full_lc->getDictionaryType());

    return false;
    // const auto & low_cardinality_rhs= static_cast<const DataTypeLowCardinality &>(rhs);
    // return dictionary_type->equals(*low_cardinality_rhs.dictionary_type);
}

DataTypePtr DataTypeLowCardinality::getFullLowCardinalityTypePtr() const
{
    return std::make_shared<DataTypeFullLowCardinality>(getDictionaryType());
}

DataTypeFullLowCardinality::DataTypeFullLowCardinality(DataTypePtr dictionary_type_)
        : DataTypeLowCardinality(dictionary_type_)
{
}

SerializationPtr DataTypeLowCardinality::doGetDefaultSerialization() const
{
    return std::make_shared<SerializationLowCardinality>(dictionary_type);
}

SerializationPtr DataTypeFullLowCardinality::doGetDefaultSerialization() const
{
    return std::make_shared<SerializationFullLowCardinality>(dictionary_type);
}

static DataTypePtr create(const ASTPtr & arguments)
{
    if (!arguments || arguments->children.size() != 1)
        throw Exception("LowCardinality data type family must have single argument - type of elements",
                        ErrorCodes::NUMBER_OF_ARGUMENTS_DOESNT_MATCH);

    return std::make_shared<DataTypeLowCardinality>(DataTypeFactory::instance().get(arguments->children[0]));
}

void registerDataTypeLowCardinality(DataTypeFactory & factory)
{
    factory.registerDataType("LowCardinality", create);
}


DataTypePtr removeLowCardinality(const DataTypePtr & type)
{
    if (const auto * low_cardinality_type = typeid_cast<const DataTypeLowCardinality *>(type.get()))
        return low_cardinality_type->getDictionaryType();
    return type;
}

}
