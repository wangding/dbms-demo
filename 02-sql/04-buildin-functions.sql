# 基础查询：内置函数

/*
 * 作用：将一组功能逻辑封装在函数体中，对外暴露函数名
 * 好处：
 *       1. 隐藏了实现细节
 *       2. 提高代码的重用性
 * 缺点：
 *       1. 不同的 DBMS 之间可移植性差，因为，类似功能的函数可能函数名不同
 * 语法：
 *       select 函数名(实参列表) [from 表名];
 * 分类：
 *       1、单行函数，如：concat, length, ifnull 等
 *       2、多行函数，如：sum, max, min, 等
 *
 * 一、单行函数
 *
 * 1. 字符串函数
 * length, char_length,
 * concat,
 * upper, lower,
 * substr, instr,
 * trim,
 * lpad, rpad,
 * replace
 *
 * 2. 数学函数
 * round, ceil, floor,
 * truncate, abs, rand
 *
 * 3. 日期函数
 * now, curdate, curtime,
 * year, month, monthname, day, hour, minute, second,
 * quarter, weekofyear, dayofyear, dayofmonth, dayofweek,
 * time_to_sec, sec_to_time,
 * date_add, adddate, date_sub, subdate, addtime, subtime,
 * datediff, timediff, from_days, to_days, last_day, makedate, maketime,
 * date_format, time_format, str_to_date
 *
 * 4. 信息函数
 * version, database, user
 *
 * 5. 控制函数
 * if, case
 *
 * 二、多行函数
 * sum, avg, max, min, count
*/

# 单行函数

## 字符串函数

# 1. length 取字节个数，char_length 取字符个数

select length('mysql'), length('王顶'), char_length('王顶');

show variables like '%char%'

# 2. concat 拼接字符串

select concat(first_name, ' ', last_name) as fullname
from northwind.employees;

# 3. upper, lower 大小写转换

select upper('john'), lower('MySQL');

# 4. substr 取子串

/*
 * 注意：索引从 1 开始
 * 截取从指定索引处后面所有字符
 * 截取从指定索引处指定字符长度的字符
*/

select substr('hello world', 7), substr('hello world', 1, 5);

# 5. instr 取子串出现的位置

/* 返回子串第一次出现的索引，如果找不到返回 0 */

select instr('hello mysql', 'mysql'), instr('hello mysql', 'world');

# 6. trim 去除多余空格

select trim(' wang ding    '), trim('a' from 'aaHELLOaaWORLDaa');

# 7. lpad, rpad 左/右填充某字符达到指定长度

select lpad('wangding', 10, '*'), rpad('wangding', 10, '*');

# 8. replace 替换

select 'hello world' as "before", replace('hello world', 'world', 'mysql') as "after";

## 数学函数

# 1. round 四舍五入

select round(-1.55), round(1.567, 2);

# 2. ceil 上取整, floor 下取整

select ceil(-1.02), floor(-9.99);

# 3. truncate 截断

select truncate(1.69999, 1), truncate(1.69999, 3);

# 4. abs 绝对值

select abs(-3), abs(3);

# 5. rand 随机数

select rand(), round(rand() * 100);

## 日期函数

# 1. 取当前日期和时间

/*
 * now     返回当前系统日期和时间
 * curdate 返回当前系统日期
 * curtime 返回当前系统时间
*/

select now(), curdate(), curtime();

# 2. 取时间和日期的部分信息

/*
 * year
 * month
 * monthname
 * day
 * hour
 * minute
 * second
 * quarter    返回日期对应的季度，范围为 1～4
 * weekofyear 返回一年中的第几周
 * dayofyear  返回日期是一年中的第几天
 * dayofmonth 返回日期位于所在月份的第几天
 * dayofweek  返回周几，注意：周日是 1，依次类推
*/

select
  now(),
  year(now()),
  month(now()),
  monthname(now()),
  day(now()),
  hour(now()),
  minute(now()),
  second(now())
from dual;

select
  curdate(),
  quarter(now()) as quarter,
  weekofyear(now()) as weekofyear,
  dayofyear(now()) as dayofyear,
  dayofmonth(now()) as dayofmonth,
  dayofweek(now()) as dayofweek
from dual;

# 3. 时间和秒的相互转换

/*
 * time_to_sec 将时间转化为秒
 * sec_to_time 将秒转换成时间
 *
 * 秒数只跟时间有关系，跟日期无关
 * 转化公式：h×3600 + m×60 + s
*/

select curtime(), time_to_sec(now()), sec_to_time(time_to_sec(now()));

# 4. 计算时间和日期

/*
 * adddate, date_add
 * subdate, date_sub
 *
 * 参数：datetime, interval expr unit
 * 功能：返回与 datetime 相差 interval 的日期时间
 * unit：参考 MySQL 手册
*/

select
  curdate(),
  adddate(curdate(), interval -1 year) as "y-1",
  adddate(curdate(), interval 1 day) as "day+1",
  adddate(curdate(), interval '1_1' year_month) as "y+1,m+1",
  adddate(curdate(), 1) as "day+1",
  curtime(),
  adddate(curtime(), interval 1 second) as "s+1",
  adddate(curtime(), interval '1_1' minute_second) as "m+1,s+1"
from dual;

/*
 * addtime
 * subtime
 *
 * 参数：expr1, expr2
 * 功能：返回 exp1 +/- expr2 的时间/日期
*/

select
  curtime(),
  addtime(curtime(), 20) as "sec+20",
  subtime(curtime(), 30) as "sec-30",
  subtime(curtime(), '1:1:3') as "now - 1:1:3"
from dual;

/*
 * datediff(expr1, expr2)          返回 expr1 - expr2 的天数
 * timediff(expr1, expr2)          返回 expr1 - expr2 的时间
 * from_days(n)                    返回从 0000 年 1 月 1 日起，n 天以后的日期
 * to_days(date)                   返回日期 date 距离 0000 年 1 月 1 日的天数
 * last_day(date)                  返回 date 所在月份的最后一天的日期
 * makedate(year, dayofyear)       针对给定年份与所在年份中的天数返回一个日期
 * maketime(hour, minute, second)  将给定的小时、分钟和秒组合成时间并返回
*/

select
  now(),
  datediff(now(), '2023-1-01') as "days",
  timediff(now(), subdate(now(), 1)) as "time",
  from_days(3650),
  to_days(now()),
  last_day(now()),
  makedate(year(now()), 35) as "makeDate",
  maketime(10, 21, 23) as "makeTime"
from dual;

# 5. 格式化

/*
 * date_format(date, format)
 * time_format(time, format)
 *
 * fromt 格式化字符串中的占位符，参考 MySQL 手册
*/

select
  curdate(),
  date_format(curdate(), '%Y 年 %M %D'),
  date_format(now(), '%m/%d-%y')
from dual;

select
  curtime(),
  time_format(curtime(), '%H 点 %i 分 %s 秒'),
  time_format(curtime(), '%h 点 %i 分 %s 秒')
from dual;

# 6. str_to_date 字符串转日期

select
  str_to_date('1998-3-2', '%Y-%m-%d'),
  str_to_date('May 1, 2013', '%M %d,%Y')
from dual;

## 信息函数

# 1. version  查询 MySQL 版本号
# 2. user     查询当前登录的账户
# 3. database 查询当前使用的数据库

select version(), user(), database();

## 流程控制函数

# 1. if(exp1, exp2, exp3)

# if(expr, true-value, false-value)

select if(10 < 5, 'true', 'false') as "10 < 5";
select if(10 < 5, true, false) as "10 < 5";

select last_name, commission_pct, if(commission_pct is null, '没提成', '有提成') as "commission"
from northwind.employees;

# 2. case

/*
case [field_x]
  when yy then [statement-1]
  when yy then [statement-2]
  ...
  else [statement-n]
end

yy: contant-value   需要 case [field_x]
yy: condition expr  需要 case
*/

/* 类似：
 * switch(var){
 *   case 1：
 *      语句1;
 *      break;
 *   ...
 *   default:
 * }
*/

/*
 * 查询员工的工资、部分编号和 new_salary，其中 new_salary 的计算如下
 *   部门编号如果是 30，new_salary 为 1.1 倍工资
 *   部门编号如果是 40，new_salary 为 1.2 倍工资
 *   部门编号如果是 50，new_salary 为 1.3 倍工资
 *   其他部门，new_salary 为原工资
*/

select salary, department_id,
  case department_id
    when 30 then salary*1.1
    when 40 then salary*1.2
    when 50 then salary*1.3
    else salary
  end as new_salary
from northwind.employees;

/* 类似
 * if(con1){
 *   语句1；
 * } else if(con2){
 *   语句2；
 * } else {
 *   语句n;
 * }
*/

/*
 * 查询员工的名字、工资以及工资级别 grade，grade 计算如下
 *   如果工资大于 20000，grade 为 A 级
 *   如果工资大于 15000，grade 为 B 级
 *   如果工资大于 10000，grade 为 C 级
 *   否则，grade 为 D 级
*/

select first_name, salary,
  case
  when salary > 20000 then 'A'
  when salary > 15000 then 'B'
  when salary > 10000 then 'C'
  else 'D'
  end as grade
from northwind.employees;

# 查询员工编号、名字、工资、以及工资提高百分之 20% 后的结果 new_salary

select employee_id, first_name, salary, salary * 1.2 as new_salary
from northwind.employees;

# 将员工的姓氏按首字母升序排序，并查询姓氏和姓氏的长度 length

select last_name, length(last_name) as "length"
from northwind.employees
order by substr(last_name, 1, 1);

# 查询员工编号、名字，薪水，作为一个列输出（逗号分割），别名为 output

select concat(employee_id, ',', first_name, ',', salary) as output
from northwind.employees;

# 查询员工编号、工作的年数 work_years（保留小数点后 1 位）、工作的天数 work_days，并按工作年数的降序排序

select
  employee_id,
  truncate(datediff(now(), hire_date) / 365, 1) as work_years,
  datediff(now(), hire_date) as work_days
from northwind.employees
order by work_years desc;

# 查询员工名字、入职时间（格式：MM-DD/YYYY）、部门编号、提成，并同时满足以下条件：
# 入职时间在 1997 年之后
# 部门编号是 80 或 90 或 110
# 提成不为空

select
  first_name,
  date_format(hire_date, '%m-%d/%Y') as "hiredate",
  department_id,
  commission_pct
from northwind.employees
where commission_pct is not null and
  department_id in (80, 90, 110) and
  datediff(hire_date, '1997-01-01') > 0;

# 查询入职超过 10000 天的员工名字和入职时间

select first_name, hire_date
from northwind.employees
where datediff(now(), hire_date) > 10000;

# 查询 dream，dream = <first_name> earns <salary> monthly but wants <salary>*3
# salary 不要小数部分

select concat(first_name, ' earns ', truncate(salary, 0), ' monthly but wants ', truncate(salary*3, 0)) as dream
from northwind.employees;

# 查询员工名字、工种以及工种的等级，其中工种的等级如下：
/*
job_id   grade
---------------
AD_PRES    A
ST_MAN     B
IT_PROG    C
SA_REP     D
ST_CLERK   E
*/

select first_name, job_id, (
  case job_id
  when 'AD_PRES' then 'A'
  when 'ST_MAN' then 'B'
  when 'IT_PROG' then 'C'
  when 'SA_REP' then 'D'
  when 'ST_CLERK' then 'E'
  end
) as grade
from northwind.employees;

# 多行函数

/*
 * 功能：用作统计使用，又称为聚合函数、统计函数
 *
 * 分类：
 *    sum 求和
 *    avg 平均值
 *    max 最大值
 *    min 最小值
 *    count 计算个数
 *
 * 特点：
 *
 * 1. sum、avg 一般用于处理数值型
 * 2. max、min、count 可以处理任何类型
 * 3. 以上分组函数都忽略 null 值
 * 4. 可以和 distinct 搭配实现去重的运算
 * 5. 和分组函数一同查询的字段要求是 group by 后的字段
*/

# 1. 简单的使用

# 查询员工工资的最大值、最小值、平均值、总和和数量

select
  sum(salary),
  avg(salary),
  min(salary),
  max(salary),
  count(salary)
from northwind.employees;

# 2. 参数支持哪些类型

select
  max(first_name),
  min(first_name),
  count(first_name)
from employees;

# 查询最早入职时间、最近入职时间以及两者相差的天数 diff

select
  max(hire_date),
  min(hire_date),
  datediff(max(hire_date), min(hire_date)) as diff
from employees;

# 3. 是否忽略null

select
  sum(commission_pct),
  avg(commission_pct),
  max(commission_pct),
  min(commission_pct),
  count(commission_pct)
from northwind.employees\G

# 4. 和 distinct 搭配

select salary
from northwind.employees
order by salary;

select
  sum(distinct salary),
  avg(distinct salary),
  min(distinct salary),
  max(distinct salary),
  count(distinct salary)
from northwind.employees\G

# 5. count 函数的详细介绍

select count(salary)
from northwind.employees;

select count(*)
from northwind.employees;

select count(1)
from northwind.employees;

/*
 * 效率：
 * myisam 存储引擎下，count(*) 的效率高
 * innodb 存储引擎下，count(*) 和 count(1) 的效率差不多，比 count(字段) 要高一些
*/

# 6. 和分组函数一同查询的字段有限制

select avg(salary), employee_id
from northwind.employees;

# 查询部门编号为 90 的员工人数

select count(*)
from northwind.employees
where department_id = 90;

select first_name, department_id
from employees
where department_id = 90;
