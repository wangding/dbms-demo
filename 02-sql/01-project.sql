# 基础查询：投影操作

/*
 * 语法：
 *       select 字段列表
 *       from   表名;
 * 特点：
 *
 * 1. 查询列表可以是：表中的字段、常量值、表达式、函数
 * 2. 查询的结果是一个虚拟的表格
*/

# 1. 查询常量值

# 查询常量值 hello world

select 'hello world';

select 'wang ding' from dual;

# 2. 查询表中的单个字段

# 查询 employees 表的结构

desc northwind.employees;

# 在 employees 表中，查询 first_name 字段

select first_name from northwind.employees;

# 3. 查询表中的多个字段

# 在 employees 表中，查询 first_name，last_name 和 salary 字段

select first_name, last_name, salary
from northwind.employees;

# 4. 查询表中的所有字段

# 方式一：逐一写出所有字段，优点：字段可以排序；缺点：代码量大

select
  `employee_id`, `first_name`, `last_name`, `email`,
  `phone_number`, `job_id`, `salary`, `commission_pct`,
  `manager_id`, `department_id`, `hire_date`
from northwind.employees;

# 方式二：使用 * 号代表所有字段，优点：代码简洁；缺点：字段顺序不能调整

select * from northwind.employees;

# 5. 查询表达式

# 查询表达式，计算半径为 4 的圆的面积

select 3.14 * 4 * 4;

# 6. 查询函数

# 查询函数，获得当前 MySQL 服务器的版本

select version();

# 查询函数，获得当前登录的用户

select user();

# 查询函数，获得当前时间

select now();

# 查询表达式，使用幂函数，计算半径为 4 的圆的面积

select 3.14 * power(4, 2);

# 7. 别名

/*
 * 别名的作用：
 *
 * 1. 便于理解
 * 2. 查询的字段有重名时，别名可以区分开来
*/

# 方式一：使用 as 关键字

select version() as version;
select user() as user;
select now() as now;
select 3.14 * power(4, 2) as area;
select 'wang ding' as name;

# 在 employees 表中，查询 employee_id, last_name 和 annual_salary 字段

select employee_id, last_name, salary * 12 as annual_salary
from northwind.employees;

# 方式二：不用 as 关键字（不推荐，可读性不好）

select version() version;

select employee_id, last_name, salary * 12 annual_salary
from northwind.employees;

# 8. + 运算符

/*
 * 大部分高级语言中的 + 运算符，有下面两个作用：
 *
 * 1. 加法运算符，数值求和
 * 2. 连接运算符，拼接两个字符串
 *
 * MySQL 中的 + 运算符只有数值求和功能
 * MySQL 中用 concat 函数完成字符串拼接
 *
*/

# 查询 employees 表的 first_name 和 last_name，拼接为 fullname

select concat(first_name, ' ', last_name)
from northwind.employees;

# 查询 employees 表的 first_name 和 last_name，拼接为 fullname，显示结果为 fullname

select concat(first_name, ' ', last_name) as fullname
from northwind.employees;

# 查询 employees 表的 first_name 和 last_name，拼接为 fullname，显示结果为 employee fullname

select concat(first_name, ' ', last_name) as "employee fullname"
from northwind.employees;

# 查询 employees 表 first_name, last_name, job_id 和 commission_pct 列，各个列之间用逗号连接，列头显示成out_put

select concat(
  `first_name`, ',',
  `last_name`, ',',
  `job_id`, ',',
  ifnull(commission_pct, 0)) as output
from northwind.employees;

# 9. 去重

# 查询 departments 表的结构

desc northwind.departments;

# 查询 departments 表中的全部数据

select *
from northwind.departments;

# 查询 employees 表中所有不同的部门编号

select department_id
from northwind.employees;

select distinct department_id
from northwind.employees;

# 查询 employees 表中的不同的 job_id

select job_id
from northwind.employees;

select distinct job_id
from northwind.employees;
