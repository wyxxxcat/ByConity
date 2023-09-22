#!/bin/bash

###
#
# This script test both part writer and part merger.
# A basic usage is:
# 1. Make sure `clickhouse` binary is built under `build/programs`.
# 2. Just run this script `bash tests/programs/test-part-tools.sh`.
# 
# For each test case, it will:
# 1. Generate test CSV data.
# 2. Call part-writer to write parts into `$WRITER_LOCATION`.
# 3. Call part-merger to merge parts into `$MERGER_LOCATION`.
# 
# During the execution, the following properties are tested:
# 1. Part-writer and Part-merger are executed without error.
# 2. After the execution, some of the parts must be merged.
#
# S3 test cases are also provided:
# Prerequisites:
# 1. Start docker via `docker-compose -f docker/CI/s3/docker-compose.yml up -d`.
#       Otherwise, you can choose to use a different S3 option that suits your preference.
# 2. Set environment variables `S3_ENDPOINT`, `S3_BUCKET`, `S3_AK_ID`, `S3_AK_SECRET`.
# 3. Run this script.
#
###

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
CSV_FILE="test-data.csv"
PARTITION_VALUE="2020-01-01"
CLICKHOUSE_BIN=${CLICKHOUSE_BIN:-"$SCRIPT_DIR/../../build/programs/clickhouse"}
# HDFS_HOST is used by CI to bypass nnproxy.
PART_TOOLS_HDFS_DIR=${PART_TOOLS_HDFS_DIR:-"hdfs://$HDFS_HOST/home/byte_dataplatform_olap_engines/user/clickhouse/ci"}
WRITER_LOCATION="$PART_TOOLS_HDFS_DIR/writer-test"
MERGER_LOCATION="$PART_TOOLS_HDFS_DIR/merger-test"

test_writer_and_merger ()
{
  DATA_ROWS="${1:-5000}"
  SCHEMA="$2"

  # Change dir.
  cd "$SCRIPT_DIR" || exit

  # Remove old files.
  rm $CSV_FILE 2> /dev/null

  # Generate the data file.
  for ((i=1;i<=DATA_ROWS;i++))
  do
    $3 $i >> $CSV_FILE 
  done

  set -ex

  # Run part-writer.
  $CLICKHOUSE_BIN part-writer "load CSV file '$CSV_FILE' as table default.tmp $SCHEMA location '$WRITER_LOCATION' settings max_insert_block_size=$MAX_INSERT_BLOCK_SIZE,min_insert_block_size_rows=0,min_insert_block_size_bytes=0" | tee current_writer_log.txt

  # Run part-merger.
  UUID=$(grep -ha -m 1 "MergeTreeCNCHDataDumper.*[0-9a-f]\{8\}-[0-9a-f]\{4\}-[0-9a-f]\{4\}-[0-9a-f]\{4\}-[0-9a-f]\{12\}" current_writer_log.txt | grep -E -o "[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}")

  $CLICKHOUSE_BIN part-merger --create-table-sql "create table my_db.tmp $SCHEMA" \
    --source-path "$WRITER_LOCATION/" \
    --output-path "$MERGER_LOCATION/$UUID" \
    --uuids "$UUID" \
    --settings "max_merge_threads=3" \
    --verbose

  set +e

  hdfs dfs -ls "$MERGER_LOCATION/$UUID/"
  hdfs dfs -rm -r "$WRITER_LOCATION/$UUID/" "$MERGER_LOCATION/$UUID/"
  rm -r $CSV_FILE

  set +x
  
  echo succeeded!
}

data_horizontal ()
{
  echo $PARTITION_VALUE, "$1"
}

data_lowcardinality ()
{
  RANDOM_VAL_1=$((RANDOM % 50 + 1))
  echo $PARTITION_VALUE, "$1", "$RANDOM", "$RANDOM_VAL_1", \\N,
}

data_basic ()
{
  key=$((RANDOM % 50 + 1))
  echo $PARTITION_VALUE, "$1", "\"{'k$key':$RANDOM}\""
}

data_multi ()
{
  key=$((RANDOM % 50 + 1))
  RANDOM_VAL_1=$((RANDOM % 100 + 1))
  echo $PARTITION_VALUE, "$1", "\"{'k$key':$RANDOM}\"", "\"{'k$key':$RANDOM}\"", $RANDOM_VAL_1,
}

if [[ -z $SKIP_HDFS_TEST ]]; then
  MAX_INSERT_BLOCK_SIZE=2000
  echo "TEST: Small blocks (Horizontal)."
  test_writer_and_merger 20000 "(p_date Date, id Int32) ENGINE=CloudMergeTree(my_db, tmp) PARTITION BY (p_date) ORDER BY (id)" data_horizontal

  echo "TEST: Small blocks (Vertical)."
  test_writer_and_merger 20000 "(p_date Date, id Int32, kv Map(String, Int32)) ENGINE=CloudMergeTree(my_db, tmp) PARTITION BY (p_date) ORDER BY (id)" data_basic

  MAX_INSERT_BLOCK_SIZE=1000000
  echo "TEST: LowCardinality"
  test_writer_and_merger 100000 "(p_date Date, id Int32, kv Int32, lc1 LowCardinality(Int), lc2 LowCardinality(Nullable(Int))) ENGINE=CloudMergeTree(my_db, tmp) PARTITION BY (p_date) ORDER BY (id)" data_lowcardinality

  echo "TEST: Map"
  test_writer_and_merger 100000 "(p_date Date, id Int32, kv Map(String, Int32), kv2 Map(String, LowCardinality(Nullable(Int))), lc1 LowCardinality(Int), lc2 LowCardinality(Nullable(Int))) ENGINE=CloudMergeTree(my_db, tmp) PARTITION BY (p_date) ORDER BY (id)" data_multi

  echo "TEST: Large data"
  test_writer_and_merger 2000000 "(p_date Date, id Int32, kv Map(String, Int32), kv2 Map(String, LowCardinality(Nullable(Int))), lc1 LowCardinality(Int), lc2 LowCardinality(Nullable(Int))) ENGINE=CloudMergeTree(my_db, tmp) PARTITION BY (p_date) ORDER BY (id)" data_multi
else
  echo "SKIP: HDFS related tests"
fi

INI_FILE="s3-config.ini"
S3_AK_PREFIX="test-root-prefix"
S3_BUCKET=${S3_BUCKET:-part-tools}

# Delete s3 config file.
test_writer_s3_clean_config () {
  rm -rf $INI_FILE
}

# After executing this function, a config file should be generated.
test_writer_s3_generate_config () {
  cat > $INI_FILE << EOF
[s3]
endpoint=$S3_ENDPOINT 
bucket=$S3_BUCKET
ak_id=$S3_AK_ID
ak_secret=$S3_AK_SECRET
root_prefix=$S3_AK_PREFIX
EOF
  echo 
}

# Only enable s3 related test if `S3_ENDPOINT` is provided.
if [[ -n $S3_ENDPOINT ]]; then
  echo "TEST: test_writer_s3 "

  # Generate random ID.
  ID=$(echo $RANDOM | md5sum | head -c 20)
  
  # Change dir.
  cd "$SCRIPT_DIR" || exit

  # Generate S3 config file.
  test_writer_s3_generate_config
  
  # Remove old files.
  rm $CSV_FILE 2> /dev/null

  # Generate the data file.
  DATA_ROWS="${1:-5000}"
  for ((i=1;i<=DATA_ROWS;i++))
  do
    data_basic $i >> $CSV_FILE 
  done

  set -ex

  LOCATION="#user#bytehouse#ci#test#$ID"
  
  # Test from local to S3.
  $CLICKHOUSE_BIN part-writer "LOAD CSV file '$CSV_FILE' AS TABLE \`default\`.\`tmp\` (p_date Date, id Int32, kv Map(String, Int32)) PRIMARY KEY id ORDER BY id LOCATION '$LOCATION' SETTINGS cnch=1, max_partitions_per_insert_block=10000, max_insert_block_size=1048576, s3_output_config='$INI_FILE'"

  # Test cleaner
  $CLICKHOUSE_BIN part-writer "CLEAN S3 task all '$LOCATION' settings s3_config='$INI_FILE'"

  set +ex
else
  echo "SKIP: S3 related tests"
fi
