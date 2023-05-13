# 行格式

# 一、基本操作

# 查看 MySQL 默认的行格式

show global variables like '%row_format%';

# 查看 northwind.employees 表的行格式

show table status from northwind like 'employees'\G

# 创建 tb_rf(id int, name char)

create table st.tb_rf (
  id int,
  name char
);
show tables from st;

# 查看表 tb_rf 的行格式

show create table st.tb_rf\G
show table status from st like 'tb_rf'\G

# 修改 tb_rf 表的行格式为 compact

alter table st.tb_rf row_format=compact;

# 二、compact 行格式

# 创建 tb_cmpt 表，行格式为 compact，字符集为 latin1

create table st.tb_cmpt (
  col1 varchar(10),
  col2 varchar(10),
  col3 char(10),
  col4 varchar(10)
) charset=latin1, row_format=compact;
show tables from st;
show create table st.tb_cmpt\G

# 在 tb_cmpt 表中插入两行记录

insert into st.tb_cmpt values
('a', 'bb', 'ccc', 'dddd'),
('e', 'ff', 'ggg', 'hhhh');

# 表空间

# 查看系统表空间和临时表空间的路径

show variables like '%file_path%';

查看使用系统表空间还是用户表空间（独立表空间）

show variables like '%file_per_table';
