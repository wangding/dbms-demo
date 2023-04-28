# 高级查询：嵌套查询

/*
 * 出现在其他语句中的 select 语句，称为嵌套查询或子查询
 * 外部的查询语句，称为主查询或外查询
 *
 * 按结果集的行列数不同分类：
 *   标量子查询（结果集只有一行一列）
 *   列子查询（结果集只有一列多行）
 *   行子查询（结果集有一行多列）
 *   表子查询（结果集一般为多行多列）
 *
 * 按子查询出现的位置不同分类：
 * select 后面：标量子查询
 * from 后面：  表子查询
 * where 或 having 后面：标量子查询、行子查询、列子查询、表子查询
 * exists 后面
*/

# 一、where 或 having 后面

/*
 * 1. 标量子查询
 * 2. 列子查询
 * 3. 行子查询
 * 4. 表子查询
 *
 * 特点：
 *
 * 1. 子查询放在小括号内
 * 2. 子查询一般放在条件的右侧
 * 3. 标量子查询，一般搭配着单行操作符使用
 * 4. 子查询的执行优先于主查询执行，主查询的条件用到了子查询的结果
 * 5. 列子查询，一般搭配着多行操作符使用 in、any/some、all
 *    in/not in 用来测试集合成员资格
 *    any/some 和 all 结合比较运算符就是集合比较
 *    any 等价于 some，不推荐 any，建议用 some，any 语义上有歧义
 *    例如：> some (subquery), <= all (subquery)
 *          = some(..) 等价于 in, <> some(..) 不等价于 not in
 *          <> all(subquery) 等价于 not in, = all() 不等价于 in
*/

# 1. 标量子查询

# 查询工资比名为 Ellen 高的员工的名字和工资

# a. 查询 Ellen 的工资

select salary
from northwind.employees
where first_name = 'Ellen';

# b. 查询最终结果

# 方式一：自连接

select e2.first_name, e2.salary
from northwind.employees as e1, northwind.employees as e2
where e1.first_name = 'Ellen' and e1.salary < e2.salary;

# 方式二：子查询

select first_name, salary
from northwind.employees
where salary > (
  select salary
  from northwind.employees
  where first_name = 'Ellen'
);

# 查询与编号为 141 的员工工种相同，比编号为 143 的员工月薪高的员工名字、工种编号和月薪

select first_name, job_id, salary
from northwind.employees
where job_id = (
  select job_id
  from northwind.employees
  where employee_id = 141
) and salary > (
  select salary
  from northwind.employees
  where employee_id = 143
);

# 查询工资最少的员工的名字、工种和月薪

select first_name, job_id, salary
from northwind.employees
where salary = (
  select min(salary)
  from northwind.employees
);

# 查询部门编号和该部门的最低月薪 min_salary，要求部门最低月薪大于 100 号部门的最低月薪

select department_id, min(salary) as min_salary
from northwind.employees
group by department_id
having min(salary) > (
  select min(salary)
  from northwind.employees
  where department_id = 100
);

# 2. 列子查询

# 返回位置编号是 1400 和 1500 两个部门中的所有员工名字

select first_name, department_id
from northwind.employees
where department_id in (
  select distinct department_id
  from northwind.departments
  where location_id in (1400, 1500)
);

# 查询其它工种中比 it_prog 工种中任一工资低的员工的员工编号、名字、工种和月薪

select employee_id, first_name, job_id, salary
from northwind.employees
where salary < all (
  select distinct salary
  from northwind.employees
  where job_id = 'it_prog'
);

# 或着

select employee_id, first_name, job_id, salary
from northwind.employees
where salary < (
  select min(salary)
  from northwind.employees
  where job_id = 'it_prog'
);

# 查询其它工种中比 it_prog 工种所有工资都低的员工的员工编号、名字、工种和月薪

select last_name,employee_id,job_id,salary
from northwind.employees
where salary < all (
  select distinct salary
  from northwind.employees
  where job_id = 'it_prog'
) and job_id <> 'it_prog';

# 或着

select last_name, employee_id, job_id, salary
from northwind.employees
where salary < (
  select min(salary)
  from northwind.employees
  where job_id = 'it_prog'
) and job_id <> 'it_prog';

# 查询比 it_prog 工种所有工资都高的部门的部门编号和最低月薪

select department_id, min(salary) as min_salary
from northwind.employees
group by department_id
having min(salary) > all (
  select distinct salary
  from northwind.employees
  where job_id = 'it_prog'
);

# 3. 行子查询

# 查询员工编号最小并且工资最高的员工信息

select employee_id, first_name, salary
from northwind.employees
where (employee_id, salary) = (
  select min(employee_id), max(salary)
  from northwind.employees
);

# 查询 employees 的部门编号和管理者编号在 departments 表中的员工名字，部门编号和管理者编号

select first_name, department_id, manager_id
from northwind.employees
where (department_id, manager_id) in (
  select department_id, manager_id
  from northwind.departments
);

# 二、select 后面

/*
 * 仅支持标量子查询
*/

# 查询每个部门信息和该部门员工个数

select d.*, (
  select count(*)
  from northwind.employees e
  where e.department_id = d.department_id
) as num
from northwind.departments d;

# 查询 90 编号的部门员工人数占公司总人数的比例，带百分号，小数点后保留一位

select concat(truncate((
  select count(*)
  from northwind.employees
  where department_id = 90) / (
  select count(*)
  from northwind.employees)*100,1), '%') as percent
from dual;

# 三、from 后面

/*
 * 子查询结果作为临时表，要求必须起别名
*/

# 查询部门编号、该部门的平均工资 average_salary 和工资等级，平均工资去掉小数部分

select s.*, g.grade_level
from (
  select department_id, truncate(avg(salary), 0) as average_salary
  from northwind.employees
  group by department_id
) as s
join northwind.job_grades as g
on s.average_salary between lowest_sal and highest_sal;

# 四、exists 后面

/*
 * 语法：exists(query_statement)
 * 结果：1 或 0
*/

select employee_id
from northwind.employees
where salary > 30000;

select exists(
  select employee_id
  from northwind.employees
  where salary > 30000
) as 'exist salary > 30000';

# 查询有员工的部门名

# in

select department_name
from northwind.departments as d
where d.department_id in (
  select department_id
  from northwind.employees
);

# 或者
# exists

select department_name
from northwind.departments as d
where exists (
  select *
  from northwind.employees as e
  where d.department_id = e.department_id
);

# 查询和 Eleni 相同部门的员工名字和工资

select first_name, salary, department_id
from northwind.employees
where department_id = (
  select department_id
  from northwind.employees
  where first_name = 'Eleni'
);

# 查询比公司平均工资高的员工的员工编号、名字和工资，并按工资升序排序

select employee_id, first_name, salary
from northwind.employees
where salary > (
  select avg(salary)
  from northwind.employees
)
order by salary;

# 查询各部门中工资比本部门平均工资高的员工的员工编号、名字和工资

select employee_id, first_name, salary, e.department_id
from northwind.employees as e
join (
  select department_id, avg(salary) as average_salary
  from northwind.employees
  group by department_id
) as d
on e.department_id = d.department_id
where salary > d.average_salary ;

# 查询和名字中包含字母 u 的员工在相同部门的员工的员工编号和名字

select employee_id, first_name
from northwind.employees
where department_id in (
  select distinct department_id
  from northwind.employees
  where first_name like '%u%'
);

# 查询在部门 location_id 为 1700 的部门工作的员工的员工编号

select employee_id
from northwind.employees
where department_id in (
  select distinct department_id
  from northwind.departments
  where location_id = 1700
);

# 查询员工名字和工资，这些员工的上司的名字是 Steven

select first_name, salary
from northwind.employees
where manager_id in (
  select employee_id
  from northwind.employees
  where first_name = 'Steven'
);

# 查询工资最高的员工的姓名 name，`name = first_name, last_name`

select concat(first_name, ',', last_name) as name
from northwind.employees
where salary = (
  select max(salary)
  from northwind.employees
);

# 查询工资最低的员工的名字和工资

select first_name, salary
from northwind.employees
where salary = (
  select min(salary)
  from northwind.employees
);

# 查询平均工资最低的部门信息

# 方式一：
# a. 各部门的平均工资

select department_id, avg(salary) as avg_salary
from northwind.employees
group by department_id;

# b. 最低平均工资

select min(avg_salary)
from (
  select department_id, avg(salary) as avg_salary
  from northwind.employees
  group by department_id
) as abc;

# c. 部门 id

select department_id, avg(salary) as avg_salary
from northwind.employees
group by department_id
having avg(salary) = (
  select min(avg_salary)
  from (
    select department_id, avg(salary) as avg_salary
    from northwind.employees
    group by department_id
  ) as abc
);

# d. 最终，部门信息

select d.*
from northwind.departments d
where d.department_id = (
  select department_id, avg(salary) as avg_salary
  from northwind.employees
  group by department_id
  having avg(salary) = (
    select min(avg_salary)
    from (
      select department_id, avg(salary) as avg_salary
      from northwind.employees
      group by department_id
    ) as abc
  )
);

# 方式二：
select *
from northwind.departments
where department_id = (
  select department_id
  from northwind.employees
  group by department_id
  order by avg(salary) 
  limit 1
);

# 查询平均工资最低的部门信息和该部门的平均工资

select d.*, avg_salary
from northwind.departments d
join (
  select avg(salary) as avg_salary,department_id
  from northwind.employees
  group by department_id
  order by avg(salary)
  limit 1
) as ag_dep
on d.department_id = ag_dep.department_id;

# 查询平均工资最高的 job 信息

select *
from jobs
where job_id=(
  select job_id
  from northwind.employees
  group by job_id
  order by avg(salary) desc
  limit 1
);

# 查询平均工资高于公司平均工资的部门有哪些?

select department_id, avg(salary) as avg_salary
from northwind.employees
group by department_id
having avg_salary > (
  select avg(salary)
  from northwind.employees
);

# 查询所有管理者的详细信息

select *
from northwind.employees
where employee_id = any (
  select distinct manager_id
  from northwind.employees
);

# 查询各个部门中最高工资中最低的那个部门的最低工资是多少

select min(salary) ,department_id
from northwind.employees
where department_id=(
  select department_id
  from northwind.employees
  group by department_id
  order by max(salary)
  limit 1
);

# 查询平均月薪最高的部门的管理者的名字、部门编号、邮箱和月薪

select distinct a.first_name, a.department_id, a.email, a.salary
from northwind.employees as a
join northwind.employees as b
on a.employee_id = b.manager_id
where a.department_id = (
  select department_id
  from northwind.employees
  group by department_id
  order by avg(salary) desc
  limit 1
);
