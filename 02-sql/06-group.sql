# 高级查询：分组汇总

/*
 * 语法：
 *       select 字段列表
 *       from 表名
 *       [where 筛选条件]
 *       group by 分组的字段
 *       [order by 排序的字段];
 *
 * 特点：
 *
 * 1. 和分组函数一同查询的字段必须是 group by 后出现的字段
 * 2. 筛选分为两类：分组前筛选和分组后筛选
 *    针对的表          位置                    连接的关键字
 *    分组前筛选       原始表                 group by 前 where
 *    分组后筛选   group by 后的结果集        group by 后 having
 * 3. 分组可以按单个字段也可以按多个字段
 * 4. 可以搭配着排序使用
 *
 * 问题1：分组函数做筛选能不能放在 where 后面? 答：不能
 *
 * 问题2：where > group by > having
 *
 * 一般来讲，能用分组前筛选的，尽量使用分组前筛选，提高效率
*/

# 引入

# 查询所有员工人数，整个表作为一个组

select count(*)
from northwind.employees;

  # 把整个表视为一组，相当于下面的查询

  select count(*)
  from northwind.employees
  group by null;

# 查询某个部门的员工个数（人为分组）

select count(*)
from northwind.employees
where department_id = 90;

# 1. 简单的分组

# 查询员工最高工资和最低工资的差距 diff

select max(salary)-min(salary) as diff
from northwind.employees;

# 查询工种编号和该工种的员工人数 num

select job_id, count(*) as num
from northwind.employees
group by job_id;

# 查询工种编号和该工种的平均工资 average_salary（去掉小数部分）

select
  job_id,
  truncate(avg(salary), 0) as average_salary
from northwind.employees
group by job_id;

# 在 departments 表中，查询位置编号和该位置的部门个数 num

select location_id, count(*) as num
from northwind.departments
group by location_id;

# 2. 分组前筛选

# 查询部门编号和该部分员工邮箱中包含 a 字符的最高工资

select department_id, max(salary)
from northwind.employees
where email like '%a%'
group by department_id;

select department_id, max(salary)
from northwind.employees
group by department_id;

select department_id, salary, email
from northwind.employees
where department_id is null;

select department_id, salary, email
from northwind.employees
where department_id = 10;

# 查询管理者编号，以及该领导手下有提成的员工的平均工资（去掉小数）average_salary

select
  manager_id,
  truncate(avg(salary), 0) as average_salary
from northwind.employees
where commission_pct is not null
group by manager_id;

select
  manager_id,
  salary
from northwind.employees
where manager_id = 100;

# 3. 分组后筛选

# 查询部门编号和该部门的员工人数 num，只要 num>5 的数据

select department_id, count(*) as num
from northwind.employees
group by department_id
having num > 5;

# 查询工种编号和该工种有提成的员工的平均工资 average_salary，只要 average_salary>12000 的数据

select job_id, avg(salary) as average_salary
from northwind.employees
where commission_pct is not null
group by job_id
having average_salary > 12000;

# 查询管理者编号和该领导手下员工的最低工资 min_salary，只要 min_salary>5000 的数据

select manager_id, min(salary) as min_salary
from northwind.employees
group by manager_id
having min_salary > 5000;

# 查询管理者编号和该领导手下员工的最低工资 min_salary，只要 min_salary >= 6000 的数据，没有管理者的员工不计算在内

select manager_id, min(salary) min_salary
from northwind.employees
where manager_id is not null
group by manager_id
having min_salary >= 6000;

# 4. 添加排序

# 查询工种编号，以及该工种下员工工资的最大值，最小值，平均值，总和，并按工种编号降序排序

select
  job_id,
  max(salary),
  min(salary),
  avg(salary),
  sum(salary)
from northwind.employees
group by job_id
order by job_id desc;

# 查询工种编号和该工种有提成的员工的最高工资 max_salary，只要 max_salary>6000 的数据，对结果按 max_salary 升序排序

select job_id, max(salary) max_salary
from northwind.employees
where commission_pct is not null
group by job_id
having max_salary > 6000
order by max_salary;

# 查询部门编号、该部门员工人数 num 和该部门工资平均值 average_salary，并按平均工资降序排序

select
  department_id,
  count(*) as num,
  truncate(avg(salary), 0) average_salary
from northwind.employees
group by department_id
order by average_salary desc;

# 5. 按多个字段分组

# 查询部门编号、工种编号和该部门和工种的员工的最低工资 min_salary，并按最低工资降序排序

select department_id, job_id, min(salary) as min_salary
from northwind.employees
group by department_id, job_id
order by min_salary desc;
