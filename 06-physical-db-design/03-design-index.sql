# 索引的设计原则

# 适合创建索引的场景

# 1. 字段值有唯一性的限制

desc index_demo.abc;
show index from index_demo.abc;
show index from index_demo.abc_idx;

select * from index_demo.abc where id=1234;
select * from index_demo.abc_idx where id=1234;

explain select * from index_demo.abc where id=1234;
explain select * from index_demo.abc_idx where id=1234;

# 2. 频繁作为 where 查询条件的字段

select * from index_demo.abc where a=1234;
select * from index_demo.abc_idx where a=1234;

explain select * from index_demo.abc where a=1234;
explain select * from index_demo.abc_idx where a=1234;

# 3. 经常 group by 和 order by 的字段

select b, count(*) from index_demo.abc group by b;
select b, count(*) from index_demo.abc_idx group by b;

explain select b, count(*) from index_demo.abc group by b;
explain select b, count(*) from index_demo.abc_idx group by b;

select * from index_demo.abc where a=1000 order by b;
select * from index_demo.abc_idx where a=1000 order by b;

explain select * from index_demo.abc where a=1000 order by b;
explain select * from index_demo.abc_idx where a=1000 order by b;

# 4. update、delete 的 where 条件字段

select * from index_demo.abc_idx where tag = '4444----';

update index_demo.abc set b = b+10000 where tag like '34--%';
update index_demo.abc_idx set b = b+10000 where tag like '34--%';

explain update index_demo.abc set b = b+10000 where tag like '34--%';
explain update index_demo.abc_idx set b = b+10000 where tag like '34--%';

# 5. distinct 字段

select count(distinct b) from index_demo.abc;
select count(distinct b) from index_demo.abc_idx;

explain select count(distinct b) from index_demo.abc;
explain select count(distinct b) from index_demo.abc_idx;

# 6. 多表 join 连接操作时，连接条件字段

explain select x.id, x.a, y.b, y.c
from (
  select * from index_demo.abc
  where id < 10000
) as x
join (
  select * from index_demo.abc
  where id < 10000
) as y
on x.b = y.b;

explain select x.id, x.a, y.b, y.c
from (
  select * from index_demo.abc_idx
  where id < 10000
) as x
join (
  select * from index_demo.abc_idx
  where id < 10000
) as y
on x.b = y.b;

# 7. 使用类型小的列创建索引（略）

# 8. 使用字符串前缀创建索引

select * from index_demo.abc where tag like '1234%';
select * from index_demo.abc_idx where tag like '1234%';

explain select * from index_demo.abc where tag like '1234%';
explain select * from index_demo.abc_idx where tag like '1234%';

select
  count(distinct left(tag, 5)) as tag4_num,
  count(*) as num,
  count(distinct left(tag, 5)) / count(*) as tag4_pct
from index_demo.abc;

select
  count(distinct left(tag, 6)) as tag4_num,
  count(*) as num,
  count(distinct left(tag, 6)) / count(*) as tag4_pct
from index_demo.abc;

select
  count(distinct left(tag, 7)) as tag4_num,
  count(*) as num,
  count(distinct left(tag, 7)) / count(*) as tag4_pct
from index_demo.abc;

select
  count(distinct left(tag, 8)) as tag4_num,
  count(*) as num,
  count(distinct left(tag, 8)) / count(*) as tag4_pct
from index_demo.abc;

# 9. 区分度高的列适合作为索引

select * from index_demo.abc where tag = '1234----';
select * from index_demo.abc_idx where tag = '1234----';

explain select * from index_demo.abc where tag = '1234----';
explain select * from index_demo.abc_idx where tag = '1234----';

# 区分度计算

select
  count(distinct tag) as tag_num,
  count(*) as num,
  count(distinct tag)/count(*) as tag_pct
from index_demo.abc;

select
  count(distinct a) as a_num,
  count(*) as num,
  count(distinct a)/count(*) as a_pct
from index_demo.abc;

select
  count(distinct b) as b_num,
  count(*) as num,
  count(distinct b)/count(*) as b_pct
from index_demo.abc;

select
  count(distinct c) as a_num,
  count(*) as num,
  count(distinct c)/count(*) as c_pct
from index_demo.abc;

# 10. 使用最频繁的列放到联合索引的左侧

select * from index_demo.abc where b between 123 and 234;
select * from index_demo.abc_idx where b between 123 and 234;

explain select * from index_demo.abc where b between 123 and 234;
explain select * from index_demo.abc_idx where b between 123 and 234;

select * from index_demo.abc where b between 223 and 234;
select * from index_demo.abc_idx where b between 223 and 234;

explain select * from index_demo.abc where b between 223 and 234;
explain select * from index_demo.abc_idx where b between 223 and 234;

# 11. 在多个字段都要创建索引的情况下，联合索引优于单值索引

select * from index_demo.abc where b=123 and c=23;
select * from index_demo.abc_idx where b=123 and c=23;

explain select * from index_demo.abc where b=123 and c=23;
explain select * from index_demo.abc_idx where b=123 and c=23;

# 不适合创建索引的场景

# 1. 在 where 中使用不到的字段，不要设置索引
# 2. 数据量小的表最好不要使用索引
# 3. 有大量重复数据的列上不要建立索引
# 4. 避免对经常更新的表创建过多的索引
# 5. 不建议用无序的值作为索引
# 6. 删除不再使用或者很少使用的索引
# 7. 不要定义冗余或重复的索引
