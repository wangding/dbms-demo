# compound statement

## 准备工作

drop database if exists cs;
create database cs;

## cursor

# 创建存储函数 get_count，计算薪资最高员工的工资和达到 total_salary 的人数

#{
drop function if exists cs.get_count;
delimiter $
create function cs.get_count(total_salary double)
returns int
begin
  declare sum_sal double default 0.0;   # 累加工资
  declare emp_sal double;               # 员工工资
  declare emp_count int default 0;      # 累加人数

  declare emp_cursor cursor for select salary from northwind.employees order by salary desc;

  open emp_cursor;

  repeat
    fetch emp_cursor into emp_sal;
    set sum_sal = sum_sal + emp_sal;
    set emp_count = emp_count + 1;
  until sum_sal >= total_salary
  end repeat;

  close emp_cursor;
  return emp_count;
end $
delimiter ;
#}

select * from information_schema.routines
where routine_schema = 'cs';

select cs.get_count(200000);
select cs.get_count(100000);
