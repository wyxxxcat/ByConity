set dialect_type='MYSQL';
use test;
DROP TABLE IF EXISTS mysql_create_select_ddl1;
DROP TABLE IF EXISTS mysql_create_select_ddl2;
DROP TABLE IF EXISTS mysql_create_select_ddl3;
DROP TABLE IF EXISTS mysql_create_select_ddl4;
-- DROP TABLE IF EXISTS mysql_create_select_ddl5;
CREATE TABLE mysql_create_select_ddl1
(
    `id` Int32 NULL,
    `val1` timestamp NOT NULL COMMENT '中文',
    `val2` varchar NOT NULL DEFAULT 'a',
    CLUSTERED KEY(id, val1, val2),
    PRIMARY KEY(id)
)
ENGINE = 'XUANWU'
PARTITION BY VALUE((toString(val1), id))
STORAGE_POLICY = 'MIXED'
hot_partition_count = 10
BLOCK_SIZE=4096
RT_ENGINE='COLUMNSTORE'
TABLE_PROPERTIES = '{"format":"columnstore"}'
TTL toDateTime(val1) + 1
COMMENT 'a';

CREATE TABLE mysql_create_select_ddl2 ENGINE=CnchMergeTree() ORDER BY id AS SELECT * FROM mysql_create_select_ddl1;
CREATE TABLE mysql_create_select_ddl3 ORDER BY id AS SELECT * FROM mysql_create_select_ddl1;
CREATE TABLE mysql_create_select_ddl4 AS SELECT * FROM mysql_create_select_ddl1;
-- CREATE TABLE mysql_create_select_ddl5 PRIMARY KEY(id) AS SELECT id FROM mysql_create_select_ddl1;
-- CREATE TABLE mysql_create_select_ddl5 (PRIMARY KEY(id)) AS SELECT id FROM mysql_create_select_ddl1;

show create table mysql_create_select_ddl2;
show create table mysql_create_select_ddl3;
show create table mysql_create_select_ddl4;
-- show create table mysql_create_select_ddl5;
DROP TABLE IF EXISTS mysql_create_select_ddl1;
DROP TABLE IF EXISTS mysql_create_select_ddl2;
DROP TABLE IF EXISTS mysql_create_select_ddl3;
DROP TABLE IF EXISTS mysql_create_select_ddl4;
-- DROP TABLE IF EXISTS mysql_create_select_ddl5;
