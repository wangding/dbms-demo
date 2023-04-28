# compound statement

drop database if exists cs;
create database cs;
create table cs.employees
as
select * from northwind.employees;

show databases;
show tables from cs;
select * from cs.employees;

## flow control

# 1 分支结构

# 1.1 分支结构之 if

# 声明存储过程 raise_salary1，输入员工编号。如果员工薪资低于 8000 元且工龄超过 5 年，涨薪 500 元；否则不变。

#{
drop procedure if exists cs.raise_salary1;
delimiter $
create procedure cs.raise_salary1(emp_id int)
begin
  declare emp_sal double;   # 员工工资
  declare hire_year double; # 员工入职年头

  select
    salary,
    datediff(curdate(), hire_date)/365
    into emp_sal, hire_year
  from cs.employees
  where employee_id = emp_id;

  if emp_sal < 8000 and hire_year >= 5 then
    update cs.employees set salary = salary + 500 where employee_id = emp_id;
  end if;
end $
delimiter ;
#}

select * from information_schema.routines
where routine_schema = 'cs';

select * from cs.employees
where employee_id = 104;

call cs.raise_salary1(104);

# 声明存储过程 raise_salary2，输入员工编号。如果员工薪资低于 9000 元且工龄超过 5 年，涨薪 500 元；否则涨薪 100 元。

#{
drop procedure if exists cs.raise_salary2;
delimiter $
create procedure cs.raise_salary2(emp_id int)
begin
  declare emp_sal double;   # 员工工资
  declare hire_year double; # 员工入职年头
  declare new_salary double;

  select
    salary,
    datediff(curdate(), hire_date)/365
    into emp_sal, hire_year
  from cs.employees
  where employee_id = emp_id;

  # 思考如何改成不用 else，只用 if
  if emp_sal < 9000 and hire_year >= 5 then
    set new_salary = emp_sal + 500;
  else
    set new_salary = emp_sal + 100;
  end if;

  update cs.employees set salary = new_salary where employee_id = emp_id;
end $
delimiter ;
#}

select * from information_schema.routines
where routine_schema = 'cs';

select * from cs.employees
where employee_id in (103, 104);

call cs.raise_salary2(103);
call cs.raise_salary2(104);

# 声明存储过程 raise_salary3，输入员工编号。如果员工薪资低于 9000 元且工龄超过 5 年，则涨薪到 9000，薪资大于 9000 且低于 10000，并且没有提成的员工，涨薪 500 元；其他涨薪 100 元。

#{
drop procedure if exists cs.raise_salary3;
delimiter $
create procedure cs.raise_salary3(emp_id int)
begin
  declare emp_sal double;   # 员工工资
  declare hire_year double; # 员工入职年头
  declare bonus double;     # 员工提成
  declare new_salary double;

  select
    salary,
    datediff(curdate(), hire_date)/365,
    commission_pct
    into emp_sal, hire_year, bonus
  from cs.employees
  where employee_id = emp_id;

  if emp_sal < 9000 and hire_year >= 5 then
    set new_salary = 9000;
  elseif emp_sal < 10000 and bonus is null then
    set new_salary = emp_sal + 500;
  else
    set new_salary = emp_sal + 100;
  end if;

  update cs.employees set salary = new_salary where employee_id = emp_id;
end $
delimiter ;
#}

select *
from cs.employees
where employee_id in (102, 103, 104);

call cs.raise_salary3(102);
call cs.raise_salary3(103);
call cs.raise_salary3(104);

# 1.2 分支结构之 case

# 声明存储过程 raise_salary4，输入员工编号。如果员工薪资低于 9000 元，则涨薪到 9000，薪资大于 9000 且低于 10000，并且没有提成的员工，涨薪 500 元；其他涨薪 100 元。

#{
drop procedure if exists cs.raise_salary4;
delimiter $
create procedure cs.raise_salary4(emp_id int)
begin
  declare emp_sal double;   # 员工工资
  declare bonus double;     # 员工提成
  declare new_salary double;

  select
    salary,
    commission_pct
    into emp_sal, bonus
  from cs.employees
  where employee_id = emp_id;

  case
  when emp_sal < 9000 then
    set new_salary = 9000;
  when emp_sal < 10000 and bonus is null then
    set new_salary = emp_sal + 500;
  else
    set new_salary = emp_sal + 100;
  end case;

  update cs.employees set salary = new_salary where employee_id = emp_id;
end $
delimiter ;
#}

select * from information_schema.routines
where routine_schema = 'cs';

select *
from cs.employees
where employee_id in (101, 104, 105);

call cs.raise_salary4(101);
call cs.raise_salary4(104);
call cs.raise_salary4(105);

# 声明存储过程 raise_salary5，输入员工编号。如果员工工龄是 0 年，涨薪 50；如果工龄是 1 年，涨薪 100；如果工龄是 2 年，涨薪 200；如果工龄是 3 年，涨薪 300；如果工龄是 4 年，涨薪 400；其他的涨薪 500。

#{
drop procedure if exists cs.raise_salary5;
delimiter $
create procedure cs.raise_salary5(emp_id int)
begin
  declare emp_sal double;  # 员工薪资
  declare hire_year int;   # 员工入职年头
  declare new_salary double;

  select
    salary,
    floor(datediff(curdate(), hire_date)/365)
    into emp_sal, hire_year
  from cs.employees
  where employee_id = emp_id;

  case hire_year
  when 0 then
    set new_salary = emp_sal + 50;
  when 1 then
    set new_salary = emp_sal + 100;
  when 2 then
    set new_salary = emp_sal + 200;
  when 3 then
    set new_salary = emp_sal + 300;
  when 4 then
    set new_salary = emp_sal + 400;
  else
    set new_salary = emp_sal + 500;
  end case;

  update cs.employees set salary = new_salary where employee_id = emp_id;
end $
delimiter ;
#}

select * from information_schema.routines
where routine_schema = 'cs';

select * from cs.employees
where employee_id in (101);

call cs.raise_salary5(101);

# 2 循环结构

# 2.1 循环结构之 loop

# 计算 n! = 1 × 2 × ... × n

#{
drop function if exists cs.factorial;
delimiter $
create function cs.factorial(n int)
returns int
begin
  declare fct, i int default 1;

  loop_label: loop
    set fct = fct * i;
    set i = i + 1;
    if i > n then
      leave loop_label;
    end if;
  end loop loop_label;

  return fct;
end $
delimiter ;
#}

select * from information_schema.routines
where routine_schema = 'cs';

select cs.factorial(3);
select cs.factorial(4);

# 生成 n 层法老的金字塔

#{
drop procedure if exists cs.pyramid;
delimiter $
create procedure cs.pyramid(m int)
begin
  # m 层金字塔，从上向下第 i 行，有 n 个 *，字符串长度是 l
  # 其中：n = 2*i -1，l = m + i -1
  declare i, n, l int default 1;

  declare py varchar(2048) default '\n';

  loop_label: loop
    set py = concat(py, lpad(repeat('*', 2*i-1), m+i-1, ' '), '\n');
    set i = i + 1;
    if i > m then
      leave loop_label;
    end if;
  end loop loop_label;

  select py;
end $
delimiter ;
#}

select * from information_schema.routines
where routine_schema = 'cs';

call cs.pyramid(3)\G
call cs.pyramid(4)\G

# 生成九九乘法表

#{
drop procedure if exists cs.mult_table;
delimiter $
create procedure cs.mult_table()
begin
  declare x, i int default 1;           # x * i = y
  declare expr varchar(10) default '';  # x * i = y
  declare result varchar(2048) default '\n';

  loop_one: loop
    set x = 1;

    loop_two: loop
      set expr = rpad(concat(x, '×', i, '=', x*i), 6, ' ');
      set result = concat(result, ' ', expr);
      set x = x + 1;
      if x > i then
        set result = concat(result, '\n');
        leave loop_two;
      end if;
    end loop loop_two;

    set i = i + 1;
    if i > 9 then
      leave loop_one;
    end if;
  end loop loop_one;

  select result;
end $
delimiter ;
#}

call cs.mult_table()\G

# 声明存储过程 raise_salary6，给全体员工涨薪，每次涨幅为 10%，直到全公司的平均薪资达到 12000 为止，返回上涨次数。

#{
drop procedure if exists cs.raise_salary6;
delimiter $
create procedure cs.raise_salary6(out num int)
begin
  declare avg_sal double;  # 平均工资
  declare n int default 0; # 调整次数

  loop_lab: loop
    select avg(salary) into avg_sal from cs.employees;

    if avg_sal >= 12000
      then leave loop_lab;
    end if;

    update cs.employees set salary = salary * 1.1;

    set n = n+1;
  end loop loop_lab;

  set num = n;
end $
delimiter ;
#}

select * from information_schema.routines
where routine_schema = 'cs';

select avg(salary) avg_sal
from cs.employees;

set @num = 0;
call cs.raise_salary6(@num);
select @num;

# 2.2 循环结构之 while

# 计算 n! = 1 × 2 × ... × n

#{
drop function if exists cs.factorial;
delimiter $
create function cs.factorial(n int)
returns int
begin
  declare fct, i int default 1;

  while i<=n do
    set fct = fct * i;
    set i = i + 1;
  end while;

  return fct;
end $
delimiter ;
#}

select * from information_schema.routines
where routine_schema = 'cs';

select cs.factorial(3);
select cs.factorial(4);

# 生成 n 层法老的金字塔

#{
drop procedure if exists cs.pyramid;
delimiter $
create procedure cs.pyramid(m int)
begin
  # m 层金字塔，从上向下第 i 行，有 n 个 *，字符串长度是 l
  # 其中：n = 2*i -1，l = m + i -1
  declare i, n, l int default 1;

  declare py varchar(2048) default '\n';

  while i<=m do
    set py = concat(py, lpad(repeat('*', 2*i-1), m+i-1, ' '), '\n');
    set i = i + 1;
  end while;

  select py;
end $
delimiter ;
#}

select * from information_schema.routines
where routine_schema = 'cs';

call cs.pyramid(3)\G
call cs.pyramid(4)\G

# 生成九九乘法表

#{
drop procedure if exists cs.mult_table;
delimiter $
create procedure cs.mult_table()
begin
  declare x, i int default 1;           # x * i = y
  declare expr varchar(10) default '';  # x * i = y
  declare result varchar(2048) default '\n';

  while i<=9 do
    set x = 1;

    while x<=i do
      set expr = rpad(concat(x, '×', i, '=', x*i), 6, ' ');
      set result = concat(result, ' ', expr);
      set x = x + 1;
    end while;
    set result = concat(result, '\n');

    set i = i + 1;
  end while;

  select result;
end $
delimiter ;
#}

select * from information_schema.routines
where routine_schema = 'cs';

call cs.mult_table()\G

# 声明存储过程 raise_salary6，给全体员工涨薪，每次涨幅为 10%，直到全公司的平均薪资达到 12000 为止，返回上涨次数。

#{
drop procedure if exists cs.raise_salary6;
delimiter $
create procedure cs.raise_salary6(out num int)
begin
  declare avg_sal double;  # 平均工资
  declare n int default 0; # 调整次数

  select avg(salary) into avg_sal from cs.employees;

  while avg_sal<12000 do
    update cs.employees set salary = salary * 1.1;
    set n = n+1;
    select avg(salary) into avg_sal from cs.employees;
  end while;

  set num = n;
end $
delimiter ;
#}

select * from information_schema.routines
where routine_schema = 'cs';

select avg(salary) avg_sal
from cs.employees;

set @num = 0;
call cs.raise_salary6(@num);
select @num;

# 2.3 循环结构之 repeat

# 计算 n! = 1 × 2 × ... × n

#{
drop function if exists cs.factorial;
delimiter $
create function cs.factorial(n int)
returns int
begin
  declare fct, i int default 1;

  repeat
    set fct = fct * i;
    set i = i + 1;
  until i>n
  end repeat;

  return fct;
end $
delimiter ;
#}

select * from information_schema.routines
where routine_schema = 'cs';

select cs.factorial(3);
select cs.factorial(4);

# 生成 n 层法老的金字塔

#{
drop procedure if exists cs.pyramid;
delimiter $
create procedure cs.pyramid(m int)
begin
  # m 层金字塔，从上向下第 i 行，有 n 个 *，字符串长度是 l
  # 其中：n = 2*i -1，l = m + i -1
  declare i, n, l int default 1;

  declare py varchar(2048) default '\n';

  repeat
    set py = concat(py, lpad(repeat('*', 2*i-1), m+i-1, ' '), '\n');
    set i = i + 1;
  until i>m
  end repeat;

  select py;
end $
delimiter ;
#}

select * from information_schema.routines
where routine_schema = 'cs';

call cs.pyramid(3)\G
call cs.pyramid(4)\G

# 生成九九乘法表

#{
drop procedure if exists cs.mult_table;
delimiter $
create procedure cs.mult_table()
begin
  declare x, i int default 1;           # x * i = y
  declare expr varchar(10) default '';  # x * i = y
  declare result varchar(2048) default '\n';

  repeat
    set x = 1;

    while x<=i do
      set expr = rpad(concat(x, '×', i, '=', x*i), 6, ' ');
      set result = concat(result, ' ', expr);
      set x = x + 1;
    end while;
    set result = concat(result, '\n');

    set i = i + 1;
  until i>9
  end repeat;

  select result;
end $
delimiter ;
#}

select * from information_schema.routines
where routine_schema = 'cs';

call cs.mult_table()\G

# 声明存储过程 raise_salary6，给全体员工涨薪，每次涨幅为 10%，直到全公司的平均薪资达到 12000 为止，返回上涨次数。

#{
drop procedure if exists cs.raise_salary6;
delimiter $
create procedure cs.raise_salary6(out num int)
begin
  declare avg_sal double;  # 平均工资
  declare n int default 0; # 调整次数

  select avg(salary) into avg_sal from cs.employees;

  while avg_sal<12000 do
    update cs.employees set salary = salary * 1.1;
    set n = n+1;
    select avg(salary) into avg_sal from cs.employees;
  end while;

  set num = n;
end $
delimiter ;
#}

select * from information_schema.routines
where routine_schema = 'cs';

select avg(salary) avg_sal
from cs.employees;

set @num = 0;
call cs.raise_salary6(@num);
select @num;
