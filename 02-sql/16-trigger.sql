# trigger

# 准备工作

drop database if exists tg;
create database tg;
show databases;

create table tg.tb_tg (
  id int primary key auto_increment,
  note varchar(20)
);
create table tg.tb_tg_log (
  id int primary key auto_increment,
  log varchar(40)
);
create table tg.employees
as
select employee_id, first_name, salary, manager_id
from northwind.employees;

desc tg.tb_tg;
desc tg.tb_tg_log;
desc tg.employees;

select * from tg.employees;

# 1. create trigger

# 创建名为 after_insert 的触发器，在 tb_tg 表插入数据后，向 tb_tg_log 表中插入日志信息。
# 日志信息的格式是：[datetime insert]: note

drop trigger if exists tg.before_insert;
delimiter $
create trigger tg.before_insert
after insert on tb_tg for each row
begin
  insert into tg.tb_tg_log(log)
  values(concat('[', now(), ' insert]: ', new.note));
end $
delimiter ;

show triggers from tg;

insert into tg.tb_tg(note)
values('wangding');

select * from tg.tb_tg;
select * from tg.tb_tg_log;

# 创建名为 after_delete 的触发器，在 tb_tg 表删除数据后，向 tb_tg_log 表中插入日志信息。
# 日志信息的格式是：[datetime delete]: note

drop trigger if exists tg.before_delete;
delimiter $
create trigger tg.before_delete
after delete on tb_tg for each row
begin
  insert into tg.tb_tg_log(log)
  values(concat('[', now(), ' delete]: ', old.note));
end $
delimiter ;

show triggers from tg;

delete from tg.tb_tg where id = 1;

select * from tg.tb_tg;
select * from tg.tb_tg_log;

# 定义触发器 salary_check，在员工表添加新员工前检查其薪资是否大于他领导的薪资，如果大于领导薪资，则报 sqlstate 为 45000 的错误。

#{
drop trigger if exists tg.salary_check;
delimiter $
create trigger tg.salary_check
before insert on employees for each row
begin
  declare mgr_sal double(8,2);

  select salary into mgr_sal from tg.employees
  where employee_id = new.manager_id;

  if new.salary > mgr_sal then
    signal sqlstate '45000' set message_text = 'ERROR: 薪资高于领导薪资', mysql_errno = 1001;
  end if;
end $
delimiter ;
#}

show triggers from tg;

# 通过性测试

insert into tg.employees
values(300, 'ding', 8000, 103);

# 失效性测试

insert into tg.employees
values(301, 'ying', 10000, 103);

select *
from tg.employees
order by employee_id desc
limit 5;

# 2. show trigger

show triggers from tg;

show create trigger tg.salary_check;

select * from information_schema.triggers
where trigger_schema = 'tg';

# 3. delete trigger

drop trigger if exists tg.after_insert;
