# 高级查询：多表查询

/* 一、分类
 *
 * 1. 按年代分类
 *   SQL92 标准: 仅支持内连接
 *   SQL99 标准：支持内连接和外连接（左外和右外）以及交叉连接
 *
 * 2. 按功能分类
 *   内连接
 *     等值连接
 *     非等值连接
 *     自连接
 *   外连接
 *     左外连接
 *     右外连接
 *     全外连接
 *   交叉连接
*/

# 二、PPT 对应代码

select * from join_demo.tb_a;
select * from join_demo.tb_b;

/* 1. 笛卡尔积 */
select *
from join_demo.tb_a, join_demo.tb_b;

/* 2. 交叉连接 = 笛卡尔积 */
select *
from join_demo.tb_a
cross join join_demo.tb_b;

/* 3. 内连接 */
select *
from join_demo.tb_a as a
inner join join_demo.tb_b as b
on a.c3 = b.c1;

# 或者

select *
from join_demo.tb_a as a
join join_demo.tb_b as b
on a.c3 = b.c1;

/* 4. 左外连接 */
select *
from join_demo.tb_a as a
left outer join join_demo.tb_b as b
on a.c3 = b.c1;

# 或者

select *
from join_demo.tb_a as a
left join join_demo.tb_b as b
on a.c3 = b.c1;

/* 5. 右外连接 */
select *
from join_demo.tb_a as a
right outer join join_demo.tb_b as b
on a.c3 = b.c1;

# 或者

select *
from join_demo.tb_a as a
right join join_demo.tb_b as b
on a.c3 = b.c1;

/* 6. 全外连接 */
select *
from join_demo.tb_a as a
left join join_demo.tb_b as b
on a.c3 = b.c1
union
select *
from join_demo.tb_a as a
right join join_demo.tb_b as b
on a.c3 = b.c1;

/* 7. 自然连接 */
select *
from join_demo.tb_c
natural join join_demo.tb_b;

# 或者

select *
from join_demo.tb_c
join join_demo.tb_b using(c1);

/* 补充：用笛卡尔积表示内连接 SQL92 */
select *
from tb_a, tb_b
where tb_a.c3 = tb_b.c1;

# 三、PPT 上七种连接

/* 1. A 左外连接 略，见上 */
/* 2. B 右外连接 略，见上 */
/* 3. A∩B 内连接 略，见上 */
/* 4. A - A∩B */
select *
from join_demo.tb_a as a
left join join_demo.tb_b as b
on a.c3 = b.c1
except
select *
from join_demo.tb_a as a
join join_demo.tb_b as b
on a.c3 = b.c1;

# 或者

select *
from join_demo.tb_a as a
left join join_demo.tb_b as b
on a.c3 = b.c1
where b.c1 is null;

/* 5. B - A∩B */
select *
from tb_a as a
right join tb_b as b
on a.c3 = b.c1
except
select *
from tb_a as a
join tb_b as b
on a.c3 = b.c1;

# 或者

select *
from join_demo.tb_a as a
right join join_demo.tb_b as b
on a.c3 = b.c1
where a.c1 is null;

/* 6. A∪B 全外连接 略，见上 */
/* 7. A∪B - A∩B = (A - A∩B) ∪ (B - A∩B)*/
select *
from join_demo.tb_a as a
left join join_demo.tb_b as b
on a.c3 = b.c1
union
select *
from join_demo.tb_a as a
right join join_demo.tb_b as b
on a.c3 = b.c1
except
select *
from join_demo.tb_a as a
join join_demo.tb_b as b;

# 或者

select *
from join_demo.tb_a as a
left join join_demo.tb_b as b
on a.c3 = b.c1
where b.c1 is null
union
select *
from join_demo.tb_a as a
right join join_demo.tb_b as b
on a.c3 = b.c1
where a.c1 is null;

# 四、案例

# 1 等值连接

/*
 * 多表等值连接的结果为多表的交集部分
 * 1. n 表连接，至少需要 n-1 个连接条件
 * 2. 多表的顺序没有要求
 * 3. 一般需要为表起别名
 * 4. 可以搭配前面介绍的所有子句使用，比如排序、分组、筛选
*/

# 1. 最简单的两表查询

# 查询员工名字和所在部门的名称
select first_name, department_name
from northwind.employees as e
join northwind.departments as d
on e.department_id = d.department_id;

# 2. 为表起别名

/* 作用：
 *
 * 1. 提高语句的简洁度
 * 2. 区分多个重名的字段
 *
 * 注意：
 *
 * 1. 如果为表起了别名，则查询的字段就不能使用原来的表名去限定
 * 2. 通过表的别名用表的首字母或者单词缩写表示
*/

# 查询员工名字、工种编号和工种名称

select first_name, e.job_id, job_title
from northwind.employees as e
join northwind.jobs as j
on e.job_id = j.job_id;

# 3. 两个表的顺序可以调换

# 查询员工名字、工种编号和工种名称

select first_name, e.job_id, job_title
from northwind.jobs as j
join northwind.employees as e
on e.job_id = j.job_id;

# 4. 可以筛选

# 查询有提成员工的员工名字、部门名称和提成

select first_name, department_name, commission_pct
from northwind.employees as e
join northwind.departments as d
on e.department_id = d.department_id
where commission_pct is not null;

# 查询所在城市名中第二个字符为 o 的部门名称和城市名

select department_name, city
from northwind.departments as d
join northwind.locations as l
on d.location_id = l.location_id
where city like '_o%';

# 5. 可以分组

# 查询城市名称和该城市拥有的部门数量，过滤没有部门的城市

select city, count(*) as num
from northwind.departments as d
join northwind.locations as l
on d.location_id = l.location_id
group by city;

# 查询有提成的部门，部门名称、部门的领导编号和部门的最低工资 min_salary

select department_name, d.manager_id, min(salary) as min_salary
from northwind.employees as e
join northwind.departments as d
on e.department_id = d.department_id
where e.commission_pct is not null
group by d.department_id;

# 注意：
# 1. manager_id 同时出现在两个表中，所以 select field_list 需要说明 d.manager_id
# 2. department_name 和 manager_id 出现在 select field_list 需要作为 group by 的条件

# 6. 可以排序

# 查询每个工种的工种名称和员工人数，并且按员工人数降序排序

select job_title, count(*) as num
from northwind.employees as e
join northwind.jobs as j
on e.job_id = j.job_id
group by job_title
order by num desc;

# 7. 可以实现三表连接

# 查询员工名字、部门名称和所在的城市，并按部门名称降序排序

select first_name, department_name, city
from northwind.employees as e
join northwind.departments as d
on e.department_id = d.department_id
join northwind.locations as l
on d.location_id = l.location_id
order by department_name desc;

# 1.2 非等值连接

# 查询员工的工资和工资级别

select * from northwind.job_grades;

select salary, grade_level
from northwind.employees as e
join northwind.job_grades as j
on e.salary between j.lowest_sal and highest_sal;

# 1.3 自连接

# 查询员工编号、员工名字、上司编号和名字

select
  e.employee_id,
  e.first_name,
  m.employee_id as manager_id,
  m.first_name as manager_name
from northwind.employees as e
join northwind.employees as m
on e.manager_id = m.employee_id;

# 注意：
# 自连接本质是两个相同的表连接，写代码时视为两个不相同的表连接

# 查询 90 号部门员工的工种编号和位置编号

select job_id, location_id
from northwind.employees as e
join northwind.departments as d
on e.department_id = d.department_id
where e.department_id = 90;

# 查询有提成的员工，员工名字、部门名称、位置编号和城市

select
  first_name,
  department_name,
  l.location_id,
  city
from northwind.employees as e
join northwind.departments as d
on e.department_id = d.department_id
join northwind.locations as l
on d.location_id = l.location_id
where e.commission_pct is not null;

# 查询在 toronto 市工作的员工，员工名字、工种编号、部门编号和部门名称

select
  first_name,
  job_id,
  d.department_id,
  department_name
from northwind.employees as e
join northwind.departments as d
on e.department_id = d.department_id
join northwind.locations as l
on d.location_id = l.location_id
where city = 'toronto';

# 查询每个部门的部门名称、工种名称、该工种的最低工资

select
  department_name,
  job_title,
  min(salary) min_salary
from northwind.employees as e
join northwind.departments as d
on e.department_id = d.department_id
join northwind.jobs as j
on e.job_id = j.job_id
group by department_name, job_title;

# 查询拥有部门数量大于 2 的国家，国家编号和部门数量

select country_id, count(*) num
from northwind.departments as d
join northwind.locations as l
on d.location_id = l.location_id
group by country_id
having num > 2;

# 查询名为 Lisa 的员工，员工编号、其上司编号和名字

select
  a.employee_id,
  a.manager_id,
  b.first_name
from northwind.employees a
join northwind.employees b
on a.manager_id = b.employee_id
where a.first_name = 'Lisa';

# 查询没有部门的城市

select city
from northwind.departments as d
right join northwind.locations as l
on d.location_id = l.location_id
where d.department_id is null;

# 查询任职部门名为 sal 和 it 的员工信息

select e.*
from northwind.departments as d
left join northwind.employees as e
on d.department_id = e.department_id
where d.department_name in ('sal', 'it');

# 查询名字中包含 e 的员工，其名字和工种名称

select first_name, job_title
from northwind.employees as e
join northwind.jobs as j
on e.job_id = j.job_id
where e.first_name like '%e%';

# 查询拥有部门数量大于 3 的城市，城市名和部门数量

select city, count(*) as num
from northwind.departments as d
inner join northwind.locations as l
on d.location_id = l.location_id
group by city
having num > 3;

# 查询员工人数大于 10 的部门，部门名称和员工人数，并按人数降序排序

select department_name, count(*) as num
from northwind.employees as e
inner join northwind.departments as d
on e.`department_id`=d.`department_id`
group by department_name
having num > 10
order by num desc;

# 查询员工名字、部门名称、工种名称，并按部门名称降序排序

select
  first_name,
  department_name,
  job_title
from northwind.employees as e
join northwind.departments as d
on e.department_id = d.department_id
join northwind.jobs as j
on e.job_id = j.job_id
order by department_name desc;

# 2 非等值连接

# 查询工资级别和该级别的员工人数，不包括人数小于 20 的工资级别

select
  grade_level,
  count(*) as num
from northwind.employees as e
join northwind.job_grades as g
on e.salary between g.lowest_sal and g.highest_sal
group by grade_level
having num > 20;

# 查询所有员工的名字和所属部门的名称

select first_name, department_name
from northwind.employees as e
left join northwind.departments as d
on e.department_id = d.department_id;

# 或者

select first_name, department_name
from northwind.departments as d
right join northwind.employees as e
on e.department_id = d.department_id;

# 查询所有部门的名称以及该部门的平均工资 average_salary （不要小数部分），并按平均工资降序排序

select
  department_name,
  truncate(avg(salary), 0) as average_salary
from northwind.departments as d
left join northwind.employees as e
on d.department_id = e.department_id
group by department_name
order by average_salary desc;

# 或者

select
  department_name,
  truncate(avg(salary), 0) as average_salary
from northwind.employees as e
right join northwind.departments as d
on d.department_id = e.department_id
group by department_name
order by average_salary desc;
