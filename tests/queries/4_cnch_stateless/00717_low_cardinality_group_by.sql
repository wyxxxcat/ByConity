drop table if exists tab_00717;
create table tab_00717 (a String, b StringWithDictionary) engine = CnchMergeTree order by a;
insert into tab_00717 values ('a_1', 'b_1'), ('a_2', 'b_2');
select count() from tab_00717;
select a from tab_00717 group by a order by a;
select b from tab_00717 group by b order by b;
select length(b) as l from tab_00717 group by l;
select sum(length(a)), b from tab_00717 group by b order by b;
select sum(length(b)), a from tab_00717 group by a order by a;
select a, b from tab_00717 group by a, b order by a, b;
select sum(length(a)) from tab_00717 group by b, b || '_';
select length(b) as l from tab_00717 group by l;
select length(b) as l from tab_00717 group by l, l + 1;
select length(b) as l from tab_00717 group by l, l + 1, l + 2;
select length(b) as l from tab_00717 group by l, l + 1, l + 2, l + 3;
select length(b) as l from tab_00717 group by l, l + 1, l + 2, l + 3, l + 4;
select length(b) as l from tab_00717 group by l, l + 1, l + 2, l + 3, l + 4, l + 5;
select a, length(b) as l from tab_00717 group by a, l, l + 1 order by a;
select b, length(b) as l from tab_00717 group by b, l, l + 1 order by b;
select a, b, length(b) as l from tab_00717 group by a, b, l, l + 1 order by a, b;
drop table if exists tab_00717;
