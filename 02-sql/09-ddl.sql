# DDL

/*
 * DDL 数据定义语言
 *
 * 管理对象：
 * 1. 管理数据库
 * 2. 管理表
 * 3. 管理视图、存储过程、函数、触发器，等
 *
 * 管理操作：
 * 1. 创建：create
 * 2. 修改：alter
 * 3. 删除：drop
*/

# 1 管理数据库

# 1.1 创建数据库

/*
 * 语法：create database [if not exists] 库名;
 * 用户需要有创建数据库的权限
*/

# 案例：创建数据库 library

# 方式一：使用默认字符集

create database library;
show databases;
show create database library;
show variables like 'character_%';

# 方式二：使用指定字符集

create database library2 character set 'utf8mb4';

# 方式三：避免创建数据库失败并指定字符集（推荐）

create database if not exists library character set 'utf8mb4';

/*
 * 字符集
 * 1. utf8 = utf8mb3（3 个字节）
 * 2. utf8mb4 （4 个字节）推荐，能表示的字符数量多
*/

# 1.2 管理数据库

# 查看 DBMS 中有哪些数据库

show databases;

# 切换数据库

use northwind;

# 查看当前数据库有哪些表

show tables;

# 查看当前的数据库

select database();

# 查看其他数据库有哪些表

show tables from mysql;
show tables from library;

# 1.3 修改数据库

/*
 * 很少使用，尤其是在有数据的情况下
 * 刚创建好数据库，在没有数据的情况下，才会修改数据库
*/

# 1.3.1 修改数据库的字符集

alter database library character set 'utf8mb4';

# 1.3.2 不能修改数据库的名字

/*
 * 如果需要修改数据库的名字
 * 需要先删除数据库，再重新创建数据库
*/

# 1.4 删除数据库

# 方式一：直接删除

drop database library2;

# 方式二：先判断数据库是否存在（推荐）

drop database if exists library2;

/*
 * 注意：
 * 一定不要删除四个系统数据库
 * 1. mysql
 * 2. sys
 * 3. performance_schema
 * 4. information_schema
*/

# 2. 管理表

# 2.1 创建表

/*
 * 语法：
 * create table 表名(
 *   列名 列的类型[约束] [默认值],
 *   ...
 *   列名 列的类型[(长度) 约束]
 * )
 * 用户需要有创建表的权限
*/

# 案例：创建表 books

方式一：从零开始，使用默认字符集

/* 如果没有指定表使用的字符集，则使用数据库的字符集 */

create table library.books(
  id int,
  name varchar(20),
  price double,
  author_id int,
  publish_date date
);

desc library.books;

show create table library.books;

# 案例：创建表 authors

create table if not exists library.authors (
  id int auto_increment,
  name varchar(20),
  nation varchar(10),
  primary key (id)
);

desc library.authors;

show create table library.authors;

方式二：基于现有的表创建，并导入数据

create table library.emp2
as
select employee_id, first_name, salary
from northwind.employees

show tables from library;

select * from library.emp2;

desc library.emp2;
describe northwind.employees;
show columns from northwind.employees;

create table library.emp3  # 只有表结构没有数据
as
select *
from northwind.employees
where false;

select * from library.emp3;

# 2.2 修改表

/*
 * 语法
 * alter table 表名 add|drop|modify|change column 列名 [列类型 约束];
*/

# 2.2.1 添加新字段

# 默认添加到表中最后一列

alter table library.emp2
add column hire_date date;

# 在第一列添加字段

alter table library.emp2
add column phone varchar(20) first;

# 在某列后添加字段

alter table library.emp2
add column email varchar(20) after salary;

# 2.2.2 修改列名

alter table library.emp2
change column employee_id id int(6); # 修改字段名

alter table library.emp2
change column email mail varchar(30); # 修改字段名和长度

# 2.2.3 修改字段的数据类型（很少这么做）、长度、默认值

alter table library.emp2
modify column first_name varchar(25);

alter table library.emp2
modify column first_name varchar(35) default 'abc';

# 2.2.4 删除列

alter table library.emp2
drop column mail;

# 2.2.5 修改表名

方式一：（推荐）

rename table library.emp2 to library.emp;
show tables from library;
desc library.emp;

方式二：

alter table library.emp
rename to library.emp2;

# 2.3 删除表

drop table if exists library.emp3;

/*
 * 1. 删除表结构和表中的数据，释放表空间
 * 2. 不能回滚
*/

# 2.4 清空表

select *
from library.emp2;

truncate table library.emp2;

/*
 * show variables like '%auto_increment%';
 * set auto_increment_increment=3;
*/

/*
 * truncate 不支持回滚，速度快，操作风险大，不建议使用
 * delete 支持回滚
 * 下面的代码适合在 MySQL Shell 下运行
*/

set autocommit = 0;

show variables like 'autocommit';

delete from library.emp2;
#truncate table library.emp2;

select * from library.emp2;

rollback;

select * from library.emp2;
