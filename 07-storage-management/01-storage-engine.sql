# 存储引擎

# 零、准备实验环境

drop database if exists st;
create database st;
show databases;

# 一、基本操作

# 查看 MySQL 支持哪些存储引擎

show engines\G

# 查看 northwind.employees 使用的存储引擎

show create table northwind.employees\G
show table status from northwind like 'employees'\G

# 查看 MySQL 默认的存储引擎

show variables like '%engine%';

# 二、修改存储引擎

# 创建 tb_eng 表，属性为 `id int, name varchar(20)`

create table st.tb_eng (
  id int,
  name varchar(20)
);
show tables from st;

# 查看 tb_eng 表使用的存储引擎，是否为默认的存储引擎

show create table st.tb_eng\G
show table status from st like 'tb_eng'\G

# 修改 tb_eng 表的存储引擎为 myisam

alter table st.tb_eng engine = myisam;

# 三、memory 存储引擎

# 创建 tb_mem 表，属性为 `id int, name varchar(20)`，使用 memory 存储引擎

create table st.tb_mem (
  id int,
  name varchar(20)
) engine=memory;
show tables from st;

# 查看 tb_mem 的存储引擎

show create table st.tb_mem\G
show table status from st like 'tb_mem'\G

# 在 tb_mem 中插入两条记录

insert into st.tb_mem values (1, 'wangding'), (2, 'louying');

# 通过 select 语句查看 tb_mem 表的数据

select * from st.tb_mem;

# 在文件系统下查看 tb_mem 表的数据

ls /var/lib/mysql/st   # 没有 tb_mem.ibd 数据文件

# 重启 mysqld 服务，通过 select 语句查看 tb_mem 表的数据

sudo systemctl status mysqld   # 查看 mysqld 服务运行的时间
sudo systemctl restart mysqld  # 重启 mysqld 服务运行的时间
sudo systemctl status mysqld   # 查看 mysqld 服务运行的时间

select * from st.tb_mem;       # 没有数据，为什么？

# 四、csv 存储引擎

# 创建 tb_csv 表 `id int, name varchar(20)` 使用 csv 引擎

create table st.tb_csv (
  id int,
  name varchar(20)
) engine=csv;

show tables from st;

# 查看表 tb_csv 的引擎

show create table st.tb_csv\G
show table status from st like 'tb_csv'\G

# 在 tb_csv 中插入 (1, 'wangding'), (2, 'louying') 两条记录

insert into st.tb_csv values (1, 'wangding'), (2, 'louying');

# 通过 select 语句查看 tb_csv 表的数据

select * from st.tb_csv;

# 在文件系统下查看 tb_csv 表的数据
# cat /var/lib/mysql/st/tb_csv.CSV
