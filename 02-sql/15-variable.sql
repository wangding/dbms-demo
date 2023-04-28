# compound statement

## 准备工作

drop database if exists cs;
create database cs;

## variable

# 1 系统变量

# 1.1 查询所有全局系统变量

show global variables; # 503

# 查询所有会话系统变量

show session variables; # 517

show variables; # 默认查询的是会话系统变量

# 1.2 查询某些系统变量

show global variables like 'auto_%';
show global variables like 'datadir';

show variables like 'character_%';

# 1.3 查看指定系统变量

select @@global.max_connections;
select @@global.character_set_client;

# 错误：
select @@global.pseudo_thread_id;

# 错误：
select @@session.max_connections;

select @@session.character_set_client;

select @@session.pseudo_thread_id;

select @@character_set_client; # 先查询会话系统变量，再查询全局系统变量

# 1.4 修改系统变量的值

# 全局系统变量：
# 方式1：
set @@global.max_connections = 161;
# 方式2：
set global max_connections = 171;

# 针对于当前的数据库实例是有效的，一旦重启 MySQL 服务，就失效了

# 会话系统变量：

# 方式1：
set @@session.character_set_client = 'gbk';

# 方式2：
set session character_set_client = 'gbk';

# 针对于当前会话是有效的，一旦结束会话，重新建立起新的会话，就失效了。

# 2 用户变量

/*
用户变量：会话用户变量 vs 局部变量
会话用户变量：使用"@"开头，作用域为当前会话。
局部变量：只能使用在存储过程和存储函数中的。
*/

# 2.1 会话用户变量
/*
① 变量的声明和赋值：
# 方式1：“=”或“:=”
set @用户变量 = 值;
set @用户变量 := 值;

# 方式2：“:=” 或 into 关键字
select @用户变量 := 表达式 [from 等子句];
select 表达式 into @用户变量  [from 等子句];

② 使用
select @变量名
*/

# 方式1：
set @m1 = 1;
set @m2 := 2;
set @sum := @m1 + @m2;

select @sum;

# 方式2：
select @count := count(*) from northwind.employees;

select @count;

select avg(salary) into @avg_sal from northwind.employees;

select @avg_sal;

# 查看所有用户会话变量
select * from performance_schema.user_variables_by_thread;

# 其中 thread_id 即会话 id，MySQL 是多线程的，每个会话是一个线程
# 当然，除了会话线程外，还有其他线程

select * from performance_schema.threads\G

# 2.2 局部变量
/*
1、局部变量必须满足：
① 使用declare声明
② 声明并使用在begin ... end 中 （使用在存储过程、函数中）
③ declare的方式声明的局部变量必须声明在begin中的首行的位置。

2、声明格式：
declare 变量名 类型 [default 值];  #  如果没有default子句，初始值为null

3、赋值：
方式1：
set 变量名=值;
set 变量名:=值;

方式2：
select 字段名或表达式 into 变量名 from 表;

4、使用
select 局部变量名;
*/

# 举例：
delimiter $
create procedure cs.test_var()
begin
  declare a int default 0;
  declare b int ;
  # declare a,b int default 0;
  declare emp_name varchar(25);
  set a = 1;
  set b := 2;
  select last_name into emp_name from northwind.employees where employee_id = 101;
  select a, b, emp_name;
end $
delimiter ;

# 调用存储过程
call test_var();

# 举例1：声明局部变量，并分别赋值为employees表中employee_id为102的last_name和salary

delimiter $
create procedure cs.test_pro()
begin
  declare emp_name varchar(25);
  declare sal double(10,2) default 0.0;
  select last_name,salary into emp_name,sal
  from northwind.employees
  where employee_id = 102;
  select emp_name, sal;
end $
delimiter ;

# 调用存储过程

call test_pro();

select last_name,salary from northwind.employees
where employee_id = 102;

# 举例2：声明两个变量，求和并打印 （分别使用会话用户变量、局部变量的方式实现）

# 方式1：使用会话用户变量

set @v1 = 10;
set @v2 := 20;
set @result := @v1 + @v2;

# 查看
select @result;

# 方式2：使用局部变量
delimiter $
create procedure cs.add_value()
begin
  declare value1, value2, sum_val int;
  set value1 = 10;
  set value2 := 100;
  set sum_val = value1 + value2;
  select sum_val;
end $
delimiter ;

# 调用存储过程
call add_value();

# 举例3：创建存储过程“different_salary”查询某员工和他领导的薪资差距，并用in参数emp_id接收员工id，
# 用out参数dif_salary输出薪资差距结果。

delimiter $
create procedure cs.different_salary(in emp_id int, out dif_salary double)
begin
  # 分析：查询出emp_id员工的工资;查询出emp_id员工的管理者的id;查询管理者id的工资;计算两个工资的差值

  # 声明变量
  declare emp_sal double default 0.0; # 记录员工的工资
  declare mgr_sal double default 0.0; # 记录管理者的工资

  declare mgr_id int default 0; # 记录管理者的id

  # 赋值
  select salary into emp_sal from northwind.employees where employee_id = emp_id;

  select manager_id into mgr_id from northwind.employees where employee_id = emp_id;
  select salary into mgr_sal from northwind.employees where employee_id = mgr_id;

  set dif_salary = mgr_sal - emp_sal;

end $
delimiter ;

# 调用存储过程
set @emp_id := 103;
set @dif_sal := 0;
call different_salary(@emp_id,@dif_sal);

select @dif_sal;

select * from northwind.employees;
