# 使用索引

# 一、实验环境准备

drop database if exists index_demo;
create database index_demo;

create table index_demo.abc (
  id int(11) not null,
  tag char(8) not null,
  a int not null,
  b int not null,
  c int not null
);

delimiter $
create procedure index_demo.insertData()
begin
  declare n, a, b, c int default 0;
  declare tag char(8);

  while n<1000000 do
    set a = n % 10000;
    set b = n % 1000;
    set c = n % 100;
    set tag = rpad(n, 8, '0');
    insert into index_demo.abc values(n, tag, a, b, c);
    set n = n + 1;
  end while;
  create table index_demo.abc_idx as select * from index_demo.abc;
  alter table index_demo.abc add primary key(id);
  alter table index_demo.abc_idx add primary key(id);
  create index idx_a_b_c on index_demo.abc_idx(a, b, c);
  create index idx_b_c on index_demo.abc_idx(b, c);
  create index idx_tag on index_demo.abc_idx(tag);
  create index idx_tag4 on index_demo.abc_idx(tag(4));
end $
delimiter ;

call index_demo.insertData();

# 二、使用索引

show tables from index_demo;

desc index_demo.abc;
desc index_demo.abc_idx;

select count(*) from index_demo.abc;
select count(*) from index_demo.abc_idx;

show index from index_demo.abc;
show index from index_demo.abc_idx;

select * from index_demo.abc where a=10;
select * from index_demo.abc_idx where a=10;

explain select * from index_demo.abc where a=10;
explain select * from index_demo.abc_idx where a=10;
