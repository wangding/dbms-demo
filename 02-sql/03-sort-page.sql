# 基础查询：排序/分页

## 排序

/*
 * 语法：
 *       select 字段列表
 *       from   表名
 *       where  筛选条件
 *       order by 排序的字段或表达式;
 *
 * 特点：
 *
 * 1. asc 代表的是升序，可以省略，desc 代表的是降序
 *
 * 2. order by 子句可以支持单个字段, 别名, 表达式, 函数, 多个字段
 *
 * 3. order by 子句在查询语句的最后面，除了 limit 子句
*/

# 1. 按单个字段排序

# 查询 employees 表所有信息，按工资降序排序

select *
from northwind.employees
order by salary desc;

# 2. 添加筛选条件再排序

# 查询 employees 表中，部门编号大于等于 90 的员工信息，并按员工编号降序

select *
from northwind.employees
where department_id >= 90
order by employee_id desc;

# 3. 按表达式排序

# 查询 employees 表中，所有员工信息，按年薪降序

select *, salary*12*(1+ifnull(commission_pct,0))
from northwind.employees
order by salary*12*(1+ifnull(commission_pct,0)) desc;

# 4. 按别名排序

# 查询 employees 表中，所有员工信息，按年薪升序排序

select *, salary*12*(1+ifnull(commission_pct,0)) as annual_salary
from northwind.employees
order by annual_salary asc;

# 5. 按函数排序

# 查询 employees 表中，员工名字 first_name 和名字长度，并且按长度降序排序

select first_name, length(first_name) as len
from northwind.employees
order by len desc;

# 6. 按多个字段排序

# 查询 employees 表中，所有员工信息，先按工资降序，再按 employee_id 升序排序

select *
from northwind.employees
order by salary desc, employee_id asc;

# 查询 employees 表中，员工的名字，部门编号和年薪，按年薪降序并按姓名升序排序

select first_name, department_id, salary*12*(1+ifnull(commission_pct,0)) as annual_salary
from northwind.employees
order by annual_salary desc, first_name asc;

# 查询 employees 表中，工资不在 8000 到 17000 的员工的名字和工资，按工资降序排序

select first_name, salary
from northwind.employees
where salary not between 8000 and 17000
order by salary desc;

# 查询 employees 表中，邮箱中包含 e 的员工信息，并先按邮箱长度降序，再按部门号升序排序

select *, length(email) as len
from northwind.employees
where email like '%e%'
order by len desc, department_id asc;

## 分页

/*
 * 应用场景：当要显示的数据太多，一页显示不下，需要分页提交 sql 请求
 *
 * 语法：
 *       select 字段列表
 *       from   表名
 *       where  筛选条件
 *       order by 排序的字段或表达式
 *       limit [offset,] size;
 *
 * offset 要显示条目的起始索引（起始索引从 0 开始）
 * size 要显示的条目个数
 *
 * 特点：
 *
 * 1. limit 语句放在查询语句的最后
 * 2. 公式: offset = (page-1)*size
 *
 *    其中要显示的页数为 page，每页的条目数 size
 *    例如：
 *         page = 1，size = 10，则显示  1~10 条记录
 *         page = 2, size = 10, 则显示 11~20 条记录
*/

# 查询 employees 表的前五条员工信息

select * from northwind.employees limit 5;

select * from northwind.employees limit 0, 5;

# 查询 employees 表的第 11 条 ~ 第 25 条

select * from northwind.employees limit 10, 15;

# 查询 employees 表，有提成且工资最高的前 10 位员工信息

select *
from northwind.employees
where commission_pct is not null
order by salary desc
limit 10;
