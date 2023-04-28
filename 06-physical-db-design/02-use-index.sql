# 使用索引

# 一、实验环境准备

drop database if exists index_demo;
create database index_demo;

drop table if exists index_demo.abc;
create table index_demo.abc (
  id int(11) not null auto_increment,
  tag char(8) not null,
  a int not null,
  b int not null,
  c int not null,
  primary key (id)
);

drop table if exists index_demo.abc_idx;
create table index_demo.abc_idx (
  id int(11) not null auto_increment,
  tag char(8) not null,
  a int not null,
  b int not null,
  c int not null,
  primary key (id),
  index idx_a_b_c (a,b,c),
  index idx_b_c (b,c),
  index idx_tag (tag),
  index idx_tag4 (tag(4))
);

drop procedure if exists index_demo.insertData;
delimiter $
create procedure index_demo.insertData()
begin
  declare n, a, b, c int default 0;
  declare tag char(8);

  while n<1000000 do
    set a = n % 10000;
    set b = n % 1000;
    set c = n % 100;
    set tag = rpad(n+1, 8, '0');
    set n = n + 1;
    insert into index_demo.abc(tag, a, b, c) values(tag, a, b, c);
    insert into index_demo.abc_idx(tag, a, b, c) values(tag, a, b, c);
  end while;
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
