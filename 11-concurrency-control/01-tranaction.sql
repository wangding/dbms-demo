# 搭建实验环境

drop database if exists tx;
create database tx;
show databases;

create table tx.t (
  id  int primary key,
  val int not null
);
show tables from tx;
desc tx.t;

insert into tx.t values (1, 100), (2, 200);
select * from tx.t;

# 基本事务操作

begin;
update tx.t set val = val - 60 where id = 1;
select * from tx.t;
update tx.t set val = val + 60 where id = 2;
select * from tx.t;
commit;

begin;
update tx.t set val = val - 60 where id = 2;
select * from tx.t;
update tx.t set val = val + 60 where id = 1;
select * from tx.t;
rollback;

begin;
update tx.t set val = val - 60 where id = 2;
select * from tx.t;
update tx.t set val = val + 60 where id = 1;
select * from tx.t;
# ctrl + z 把 mysql 切换到后台，查看 pid
# kill pid，fg 确保 mysql 不能调到前台
# 进入 mysql 控制台
# tx.t 表的数据，应该回滚至初始值：(1,40), (2,260)
