CREATE TEMPORARY TABLE t (i UInt8, x Time(6));
INSERT INTO t VALUES (1, '05:20:30.5555556');
INSERT INTO t VALUES (2, '05:20:30');
INSERT INTO t VALUES (3, '05:20:30.333333333333');
INSERT INTO t VALUES (4, '05:20:30.3');
INSERT INTO t VALUES (5, NULL);
SELECT * FROM t ORDER BY i;

CREATE TEMPORARY TABLE t2 (i UInt8, x Time);
INSERT INTO t2 VALUES (1, '05:20:30.5555556');
INSERT INTO t2 VALUES (2, '05:20:30');
INSERT INTO t2 VALUES (3, '05:20:30.333333333333');
INSERT INTO t2 VALUES (4, '05:20:30.3');
INSERT INTO t2 VALUES (5, NULL);
SELECT * FROM t2 ORDER BY i;