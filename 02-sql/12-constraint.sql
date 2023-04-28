# constraint

create database cs;

show databases;

# 1. not null 约束

# 1.1 在 create table 时添加约束

create table cs.tb_null(
  id int not null,
  name varchar(15) not null,
  email varchar(25),
  salary decimal(10, 2)
);

desc cs.tb_null;

insert into cs.tb_null(id, name, email, salary)
values(1, 'wangding', 'w.ding@qq.com', 8400);

select * from cs.tb_null;

# error: column 'name' cannot be null

insert into cs.tb_null(id, name, email, salary)
values(2, null, 'wangding@126.com', 9400);

# error: column 'id' cannot be null

insert into cs.tb_null(id, name, email, salary)
values(null, 'louying', 'louying@163.com', 7400);

insert into cs.tb_null(id, email)
values(2, 'abc@163.com');

update cs.tb_null
set name = null
where id = 1;

# 1.2 在 alter table 时添加约束

select * from cs.tb_null;

desc cs.tb_null;

alter table cs.tb_null
modify email varchar(25) not null;

# 1.3 删除约束

alter table cs.tb_null
modify email varchar(25) null;

# 2. unique 约束

# 2.1 在 create table 时添加约束

create table cs.tb_unique(
  id int unique,            # 列级约束
  name varchar(15) ,
  email varchar(25),
  salary decimal(10, 2),
                            # 表级约束
  constraint uk_tb_unique_email unique(email)
);

desc cs.tb_unique;

select * from information_schema.table_constraints
where table_name = 'cs.tb_unique';

# 在创建唯一约束的时候，如果不给唯一约束命名，就默认和列名相同

insert into cs.tb_unique(id, name, email, salary)
values(1, 'wangding', 'w.ding@qq.com', 8500);

select * from cs.tb_unique;

# error: duplicate entry '1' for key 'cs.tb_unique.id'

insert into cs.tb_unique(id, name, email, salary)
values(1, 'louying', 'louying@163.com', 8600);

# error: duplicate entry 'w.ding@qq.com' for key 'uk_tb_unique_email'

insert into cs.tb_unique(id, name, email, salary)
values(2, 'wangding', 'w.ding@qq.com', 9600);

# 可以向声明为 unique 的字段上添加 null 值，而且可以多次添加 null

insert into cs.tb_unique(id, name, email, salary)
values(2, 'louying', null, 8600);

insert into cs.tb_unique(id, name, email, salary)
values(3, 'chenxin', null, 9600);

select * from cs.tb_unique;

# 2.2 在 alter table 时添加约束

desc cs.tb_unique;

# 方式 1：添加表级约束

alter table cs.tb_unique
add constraint uk_tb_unique_sal unique(salary);

# 方式 2：添加列级约束

alter table cs.tb_unique
modify name varchar(15) unique;

# 2.3 复合的 unique 约束

create table cs.user(
  id int,
  name varchar(15),
  password varchar(25),
  constraint uk_user_name_pwd unique(`name`, `password`)
);

desc cs.user;

insert into cs.user
values(1, 'wangding', 'abc');

# 可以成功

insert into cs.user
values(1, 'wangding1', 'abc');

select * from cs.user;

# 2.4 删除 unique 约束

/*
 * 添加唯一约束的列上也会自动创建唯一索引
 * 删除唯一约束只能通过删除唯一索引的方式删除
 * 删除时需要指定唯一索引名，唯一索引名和唯一约束名一样
 * 如果创建唯一约束时未指定名称，如果是单列，默认和列名相同
 * 如果是组合列，默认和第一个的列名相同
 * 也可以自定义唯一性约束名
*/

select * from information_schema.table_constraints
where table_name = 'tb_unique';

desc cs.tb_unique;

# 如何删除唯一性索引

show index from cs.tb_unique;

alter table cs.tb_unique
drop index name;

alter table cs.tb_unique
drop index uk_tb_unique_sal;

# 3. primary key 约束

# 3.1 在 create table 时添加约束

# 一个表中最多只能有一个主键约束

# error: multiple primary key defined

create table cs.tb_pk(
  id int primary key,             # 列级约束
  name varchar(15) primary key,   # 列级约束
  salary decimal(10, 2),
  email varchar(25)
);

# 主键约束特征：非空且唯一，用于实现表中记录的唯一性

show tables from cs;

create table cs.tb_pk1(
  id int primary key,         # 列级约束
  name varchar(15),
  salary decimal(10, 2),
  email varchar(25)
);

select * from information_schema.table_constraints
where table_name = 'tb_pk1';

# mysql 的主键名总是 primary，就算自己命名了主键约束名也没用

create table cs.tb_pk2(
  id int ,
  name varchar(15),
  salary decimal(10, 2),
  email varchar(25),
  # 表级约束
  constraint pk_pk2_id primary key(id)  # 没有必要起名字
);

select * from information_schema.table_constraints
where table_name = 'tb_pk2';

insert into cs.tb_pk1(id, name, salary, email)
values(1, 'wangding', 8500, 'w.ding@qq.com');

select * from cs.tb_pk1;

# error: duplicate entry '1' for key 'cs.tb_pk1.primary'

insert into cs.tb_pk1(id, name, salary, email)
values(1, 'louying', 7770, 'louying@163.com');

# error: column 'id' cannot be null

insert into cs.tb_pk1(id, name, salary, email)
values(null, 'louying', 7700, 'louying@163.com');

select * from cs.tb_pk1;

# 复合主键约束

create table cs.tb_pk3(
  id int,
  name varchar(15),
  password varchar(25),
  primary key (name, password)
);

# 如果是多列组合的复合主键约束，那么这些列都不允许为空值，并且组合的值不允许重复

insert into cs.tb_pk3
values(1, 'wangding', 'abc');

select * from cs.tb_pk3;

insert into cs.tb_pk3
values(1, 'wangding1', 'abc');

# error: column 'name' cannot be null

insert into cs.tb_pk3
values(1, null, 'abc');

select * from cs.tb_pk3;

# 3.2 在 alter table 时添加约束

create table cs.tb_pk4(
  id int ,
  name varchar(15),
  salary decimal(10, 2),
  email varchar(25)
);

desc cs.tb_pk4;

alter table cs.tb_pk4
add primary key (id);

select * from information_schema.table_constraints
where table_name = 'tb_pk4';

# 3.3 删除主键约束

# 在实际开发中，不会去删除表中的主键约束!

alter table cs.tb_pk4
drop primary key;

# 4. foreign key 约束

# 4.1 在 create table 时添加

# 主表和从表；父表和子表

# 先创建主表

create table cs.dept1(
  dept_id int,
  dept_name varchar(15)
);

# 再创建从表

create table cs.emp1(
  emp_id int,
  emp_name varchar(15),
  department_id int,
  # 表级约束
  constraint fk_emp1_dept_id foreign key (department_id) references dept1(dept_id)
);

# 操作报错，主表中的 dept_id 上没有主键约束或唯一值约束

desc cs.dept1;

# 添加主键约束

alter table cs.dept1
add primary key (dept_id);

desc cs.dept1;

# 重新创建从表

create table cs.emp1(
  emp_id int,
  emp_name varchar(15),
  department_id int,
  # 表级约束
  constraint fk_emp1_dept_id foreign key (department_id) references dept1(dept_id)
);

desc cs.emp1;

select * from information_schema.table_constraints
where table_name = 'emp1';

# 4.2 演示外键的效果

# 添加失败

insert into cs.emp1
values(1001, 'wangding', 10);

# 先给主表添加数据

insert into cs.dept1
values(10, 'it');

select * from cs.dept1;

# 再给从表添加数据才能成功

insert into cs.emp1
values(1001, 'wangding', 10);

select * from cs.emp1;

# 删除失败

delete from cs.dept1
where dept_id = 10;

# 更新失败

update cs.dept1
set dept_id = 20
where dept_id = 10;

# 4.3 在 alter table 时添加外键约束

create table cs.dept2(
  dept_id int primary key,
  dept_name varchar(15)
);

create table cs.emp2(
  emp_id int,
  emp_name varchar(15),
  department_id int
);

alter table cs.emp2
add constraint fk_emp2_dept_id foreign key(department_id) references dept2(dept_id);

select * from information_schema.table_constraints
where table_name = 'emp2';

# 4.4 约束等级

/*
 * cascade：在父表上 update/delete 记录时，同步 update/delete 掉子表的匹配记录
 * set null：在父表上 update/delete 记录时，将子表上匹配记录的列设为 null，但是要注意子表的外键列不能为 not null
 * no action：如果子表中有匹配的记录，则不允许对父表对应候选键进行 update/delete 操作
 * restrict：同 no action，都是立即检查外键约束
*/

# 演示：on update cascade on delete set null

create table dept(
  did int primary key,   # 部门编号
  dname varchar(50)      # 部门名称
);

create table emp(
  eid int primary key,   # 员工编号
  ename varchar(5),      # 员工姓名
  deptid int,            # 员工所在的部门
  foreign key (deptid) references dept(did) on update cascade on delete set null
);

insert into dept values(1001, '教学部');
insert into dept values(1002, '财务部');
insert into dept values(1003, '咨询部');

insert into emp values(1, '张三', 1001);
insert into emp values(2, '李四', 1001);
insert into emp values(3, '王五', 1002);

update dept
set did = 1004
where did = 1002;

delete from dept
where did = 1004;

select * from dept;

select * from emp;

# 结论：对于外键约束，最好是采用: on update cascade on delete restrict 的方式

# 4.5 删除外键约束

# 一个表中可以声明多个外键约束

select * from information_schema.table_constraints
where table_name = 'employees';

select * from information_schema.table_constraints
where table_name = 'cs.emp1';

# 首先，删除外键约束

alter table cs.emp1
drop foreign key fk_cs.emp1_dept_id;

# 然后，手动删除外键约束对应的普通索引

show index from cs.emp1;

alter table cs.emp1
drop index fk_cs.emp1_dept_id;

# 5. check 约束

#  mysql 5.7 不支持 check 约束，mysql 8.0 支持 check 约束。

create table cs.tb_check(
  id int,
  name varchar(15),
  salary decimal(10, 2) check(salary > 2000)
);

insert into cs.tb_check
values(1, 'wangding', 8500);

# 添加失败

insert into cs.tb_check
values(2, 'louying', 1500);

select * from cs.tb_check;

# 6. auto_increment 属性

# 6.1 在 create table 时添加

create table cs.tb_ai(
  id int primary key auto_increment,
  name varchar(15)
);

# 一旦字段上声明 auto_increment，则添加数据时，该字段不要给值

insert into cs.tb_ai(name)
values('wangding');

select * from cs.tb_ai;

# 当向 auto_increment 的字段上添加 0 或 null 时
# 实际上会自动的往上添加指定的字段的数值

insert into cs.tb_ai(id, name)
values(0, 'wangding');

insert into cs.tb_ai(id, name)
values(null, 'wangding');

insert into cs.tb_ai(id, name)
values(10, 'wangding');

insert into cs.tb_ai(id, name)
values(-10, 'wangding');

# 6.2 在 alter table 时添加

create table cs.tb_ai2(
  id int primary key,
  name varchar(15)
);

desc cs.tb_ai2;

alter table cs.tb_ai2
modify id int auto_increment;

# 6.3 删除

alter table cs.tb_ai2
modify id int;

# 7. default 属性

# 7.1 在 create table 添加

create table cs.tb_default(
  id int,
  name varchar(15),
  salary decimal(10, 2) default 2000
);

desc cs.tb_default;

insert into cs.tb_default(id, name, salary)
values(1, 'wangding', 8000);

insert into cs.tb_default(id, name)
values(2, 'louying');

select * from cs.tb_default;

# 7.2 在 alter table 添加

create table cs.tb_null2(
  id int,
  name varchar(15),
  salary decimal(10, 2)
);

desc cs.tb_null2;

alter table cs.tb_null2
modify salary decimal(8, 2) default 2500;

# 7.3 删除 default 属性

alter table cs.tb_null2
modify salary decimal(8, 2);

show create table cs.tb_null2;
