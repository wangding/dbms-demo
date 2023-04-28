# 基础查询：选择操作

/*
 * 语法：
 *       select 字段列表
 *       from   表名
 *       where  筛选条件;
 *
 * 筛选条件分类：
 *
 * 一、按条件表达式筛选
 *
 *     简单条件运算符：> < = != <> >= <=
 *
 * 二、按逻辑表达式筛选
 *
 *     逻辑运算符：&& || ! and or not
 *     作用：用于连接条件表达式
 *
 * 三、模糊查询
 *
 *     like, not like
 *     between and, not between and
 *     in, not in
 *
 * 四、特殊
 *
 *     is null, is not null
*/

# 一、按条件表达式筛选

# 查询 employees 表中，工资大于 12000 的员工信息

select *
from northwind.employees
where salary > 12000;

# 查询 employees 表中，部门编号不等于 90 的员工 last_name 和部门编号

select last_name, department_id
from northwind.employees
where department_id <> 90;

# 二、按逻辑表达式筛选

# 查询 employees 表中，工资在 10000 到 20000 之间的员工 last_name、工资以及提成

select last_name, salary, commission_pct
from northwind.employees
where salary >= 10000 and salary <= 20000;

# 查询 employees 表中，部门编号不在 90 到 110 之间，或者工资高于 15000 的员工信息

select *
from northwind.employees
where not(department_id >= 90 and department_id <= 110) or salary > 15000;

# 三、模糊查询

# 1. like, not like

/*
 * 特点：
 * 一般和通配符搭配使用
 * 通配符：
 * % 任意多个字符，包含 0 个字符
 * _ 任意单个字符
*/

# 查询 employees 表中，员工 last_name 中包含字符 a 的员工信息

select *
from northwind.employees
where last_name like '%a%';

# 查询 employees 表中，员工 last_name 中第三个字符为 n，第五个字符为 l 的员工 last_name 和工资

select last_name, salary
from northwind.employees
where last_name like '__n_l%';

# 查询 employees 表中，员工 job_id 中第三个字符为 `_` 的员工 last_name 和 job_id

select last_name, job_id
from northwind.employees
where job_id like '__\_%';

select last_name, job_id
from northwind.employees
where job_id like '__$_%' escape '$';

# 2. between and, not between and

/*
 * 1. 使用 between and 可以提高语句的简洁度
 * 2. 包含临界值
 * 3. 两个临界值不要调换顺序
*/

# 查询 employees 员工编号在 100 到 120 之间的员工信息

select *
from northwind.employees
where employee_id >= 100 and employee_id <= 120;

select *
from northwind.employees
where employee_id between 100 and 120;

# 3. in, not in

/*
 * 含义：判断某字段的值是否属于in列表中的某一项
 * 特点：
 * 1. 使用 in 提高语句简洁度
 * 2. in 列表的值类型必须一致或兼容
 * 3. in 列表中不支持通配符
*/

# 查询 employees 表中，工种编号是 it_prog、ad_vp、ad_pres 中的一个员工 last_name 和工种编号

select last_name, job_id
from northwind.employees
where job_id = 'it_prog' or job_id = 'ad_vp' or job_id ='ad_pres';

select last_name, job_id
from northwind.employees
where job_id in ('it_prog', 'ad_vp', 'ad_pres');

# 4. is null, is not null

/*
 * = 或 <> 不能用于判断 null 值
 * is null 或 is not null 可以判断 null 值
*/

# 查询 employees 表中，没有提成的员工 last_name 和提成

select last_name, commission_pct
from northwind.employees
where commission_pct <=> null;

# 查询 employees 表中，工资为 12000 的员工 last_name 和工资

select last_name, salary
from northwind.employees
where salary <=> 12000;

/*
 * is null vs <=>
 *
 * is null: 仅仅可以判断 null 值，可读性较高，建议使用
 * <=>    : 既可以判断 null 值，又可以判断普通的数值，可读性较低
*/
