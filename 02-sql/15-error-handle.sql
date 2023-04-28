# compound statement

## error handle

# 1 错误演示

# 错误代码： 1364
/* field 'email' doesn't have a default value */

insert into employees(last_name)
values('tom');

desc employees;

# 错误演示：
delimiter $
create procedure updatedatanocondition()
  begin
    set @x = 1;
    update employees set email = null where last_name = 'abel';
    set @x = 2;
    update employees set email = 'aabbel' where last_name = 'abel';
    set @x = 3;
  end $
delimiter ;

# 调用存储过程
# 错误代码： 1048
# column 'email' cannot be null
call updatedatanocondition();

select @x;

# 2.2 定义条件
# 格式：declare 错误名称 condition for 错误码（或错误条件）

# 举例1：定义“field_not_be_null”错误名与mysql中违反非空约束的错误类型
# 是“error 1048 (23000)”对应。
# 方式1：使用mysql_error_code
declare field_not_be_null condition for 1048;

# 方式2：使用sqlstate_value
declare field_not_be_null condition for sqlstate '23000';

# 举例2：定义"error 1148(42000)"错误，名称为command_not_allowed。
# 方式1：使用mysql_error_code
declare command_not_allowed condition for 1148;

# 方式2：使用sqlstate_value
declare command_not_allowed condition for sqlstate '42000';

# 2.3 定义处理程序
# 格式：declare 处理方式 handler for 错误类型 处理语句

# 举例：
# 方法1：捕获sqlstate_value
declare continue handler for sqlstate '42s02' set @info = 'no_such_table';

# 方法2：捕获mysql_error_value
declare continue handler for 1146 set @info = 'no_such_table';

# 方法3：先定义条件，再调用
declare no_such_table condition for 1146;
declare continue handler for no_such_table set @info = 'no_such_table';

# 方法4：使用sqlwarning
declare exit handler for sqlwarning set @info = 'error';

# 方法5：使用not found
declare exit handler for not found set @info = 'no_such_table';

# 方法6：使用sqlexception
declare exit handler for sqlexception set @info = 'error';

# 2.4 案例的处理

drop procedure updatedatanocondition;

# 重新定义存储过程，体现错误的处理程序
delimiter $

create procedure updatedatanocondition()
  begin
    # 声明处理程序
    # 处理方式1：
    declare continue handler for 1048 set @prc_value = -1;
    # 处理方式2：
    # declare continue handler for sqlstate '23000' set @prc_value = -1;
    
    set @x = 1;
    update employees set email = null where last_name = 'abel';
    set @x = 2;
    update employees set email = 'aabbel' where last_name = 'abel';
    set @x = 3;
  end $

delimiter ;

# 调用存储过程：
call updatedatanocondition();

# 查看变量：
select @x,@prc_value;

# 2.5 再举一个例子：
# 创建一个名称为“insertdatawithcondition”的存储过程

# ① 准备工作
create table departments
as
select * from atguigudb.`departments`;

desc departments;

alter table departments
add constraint uk_dept_name unique(department_id);

# ② 定义存储过程：
delimiter $

create procedure insertdatawithcondition()
  begin    
    set @x = 1;
    insert into departments(department_name) values('测试');
    set @x = 2;
    insert into departments(department_name) values('测试');
    set @x = 3;
  end $

delimiter ;

# ③ 调用
call insertdatawithcondition();

select @x;  # 2

# ④ 删除此存储过程
drop procedure if exists insertdatawithcondition;

# ⑤ 重新定义存储过程（考虑到错误的处理程序）

delimiter $

create procedure insertdatawithcondition()
  begin
    # 处理程序
    # 方式1：
    # declare exit handler for 1062 set @pro_value = -1;
    # 方式2：
    # declare exit handler for sqlstate '23000' set @pro_value = -1;
    # 方式3：
    # 定义条件
    declare duplicate_entry condition for 1062;
    declare exit handler for duplicate_entry set @pro_value = -1;

    set @x = 1;
    insert into departments(department_name) values('测试');
    set @x = 2;
    insert into departments(department_name) values('测试');
    set @x = 3;
  end $

delimiter ;

# 调用
call insertdatawithcondition();

select @x,@pro_value;
