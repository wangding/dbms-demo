#  view

# 准备工作

show databases;
create database vw;

create table vw.emps
as
select *
from northwind.employees;

create table vw.depts
as
select *
from northwind.departments;

select * from vw.emps;

select * from vw.depts;

desc vw.emps;
desc northwind.employees;

# 1. 如何创建视图

# 1.1 针对于单表

# 情况 1：视图中的字段与基表的字段有对应关系

create view vw.v_emp1
as
select employee_id, first_name, salary
from vw.emps;

select * from vw.v_emp1;

# 确定视图中字段名的方式 1
# 查询语句中字段的别名会作为视图中字段的名称出现

create view vw.v_emp2
as
select employee_id as emp_id, first_name as name, salary
from vw.emps
where salary > 8000;

select * from vw.v_emp2;

# 确定视图中字段名的方式 2
# 小括号内字段个数与 select 中字段个数相同

create view vw.v_emp3(emp_id, name, salary)
as
select employee_id, first_name, salary
from vw.emps
where salary > 8000;

select * from vw.v_emp3;

# 情况 2：视图中的字段在基表中可能没有对应的字段

create view vw.v_emp_sal
as
select department_id, avg(salary) avg_sal
from vw.emps
where department_id is not null
group by department_id;

select * from vw.v_emp_sal;

# 1.2 针对于多表

create view vw.v_emp_dept
as
select e.employee_id, e.department_id, d.department_name
from vw.emps as e
join vw.depts as d
on e.department_id = d.department_id;

select * from vw.v_emp_dept;

# 1.3 基于视图创建视图

create view vw.v_emp4
as
select employee_id, first_name
from vw.v_emp1;

select * from vw.v_emp4;

# 2. 查看视图

# 1) 查看数据库的表对象、视图对象
show tables from vw;

# 2) 查看视图对象
select * from information_schema.views
where table_schema = 'cs'\G

# 3) 查看视图的结构
describe vw.v_emp1;

# 4) 查看视图的属性信息
show table status from vw like 'v_emp1';

# 5) 查看视图的详细定义信息
show create view vw.v_emp1;

# 3. 修改视图中的数据

# 3.1 一般情况，可以更新视图的数据

select * from vw.v_emp1;

select employee_id, first_name, salary
from vw.emps;

# 更新视图的数据，会导致基表中数据的修改

update vw.v_emp1
set salary = 20000
where employee_id = 101;

# 同理，更新表中的数据，也会导致视图中数据的修改

update vw.emps
set salary = 10000
where employee_id = 101;

# 删除视图中的数据，也会导致表中的数据的删除

delete from vw.v_emp1
where employee_id = 101;

select employee_id, last_name, salary
from vw.emps
where employee_id = 101;

# 3.2 不能更新视图中的数据

select * from vw.v_emp_sal;

# 更新失败

update v_emp_sal
set avg_sal = 5000
where department_id = 30;

# 删除失败

delete from vw.v_emp_sal
where department_id = 30;

# 4. 修改视图

desc vw.v_emp1;

# 方式1

create or replace view vw.v_emp1
as
select employee_id, first_name, salary, email
from vw.emps
where salary > 7000;

# 方式2

alter view vw.v_emp1
as
select employee_id, first_name, salary, email, hire_date
from vw.emps;

# 5. 删除视图

show tables from vw;

drop view vw.v_emp4;

drop view if exists vw.v_emp2, vw.v_emp3;
