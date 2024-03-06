/*
 * Copyright (2022) Bytedance Ltd. and/or its affiliates
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#pragma once
#include <Core/SortDescription.h>
#include <DataStreams/SizeLimits.h>
#include <Disks/IVolume.h>
#include <QueryPlan/ITransformingStep.h>

namespace DB
{
/// Sorts stream of data. See MergeSortingTransform.
class SortingStep : public ITransformingStep
{
public:
    ENUM_WITH_PROTO_CONVERTER(
        Stage, // enum name
        Protos::SortingStep::Stage, // proto enum message
        (FULL),
        (MERGE),
        (PARTIAL)
    );

    explicit SortingStep(const DataStream & input_stream, SortDescription description_, UInt64 limit_, Stage stage_, SortDescription prefix_description_ = {});

    String getName() const override { return "Sorting"; }

    Type getType() const override { return Type::Sorting; }
    const SortDescription & getSortDescription() const { return result_description; }
    const SortDescription & getPrefixDescription() const { return prefix_description; }
    void setPrefixDescription(const SortDescription & prefix_description_) { prefix_description = prefix_description_; }
    UInt64 getLimit() const { return limit; }
    Stage getStage() const { return stage; }
    void setStage(Stage stage_) { stage = stage_; }

    void transformPipeline(QueryPipeline & pipeline, const BuildQueryPipelineSettings &) override;

    void describeActions(JSONBuilder::JSONMap & map) const override;
    void describeActions(FormatSettings & settings) const override;

    /// Add limit or change it to lower value.
    void updateLimit(size_t limit_);

    void toProto(Protos::SortingStep & proto, bool for_hash_equals = false) const;
    static std::shared_ptr<SortingStep> fromProto(const Protos::SortingStep & proto, ContextPtr);
    std::shared_ptr<IQueryPlanStep> copy(ContextPtr ptr) const override;
    void setInputStreams(const DataStreams & input_streams_) override;

private:
    const SortDescription result_description;
    UInt64 limit;
    Stage stage;
    SortDescription prefix_description;
};

}
