# DCL

一、用户管理

登录 MySQL 服务器

- `mysql –h hostname|hostip –P port –u username –p DatabaseName –e "SQL 语句"`

1.1 创建用户

- 语法：`create user 用户名 [identified by '密码'][,用户名 [identified by '密码']];`
- 用户名参数表示新建用户的账户，由用户（User）和主机名（Host）构成
- identified by 指定明文密码值
- 可以同时创建多个用户

# 创建 MySQL 用户，用户名：自己姓名的拼音，密码：123456
create user wd identified by '123456'; # 默认 host 是 %

# 创建 MySQL 用户，用户名：zhang3@localhost，密码：123456
create user 'zhang3'@'localhost' identified by '123456';

1.2 查看用户

# 查看所有用户
select host, user from mysql.user;
select * from mysql.user\G
desc mysql.user;

alter user abc identified by 'ddd';

# 查看指定用户
select * from mysql.user where user = 'wangding'\G

# 查看当前登录用户
select user();
select current_user();

1.3 修改用户

# 修改用户 zhang3 为 li4
rename user 'zhang3' to 'li4';

update mysql.user set user='li4' where user='zhang3';
flush privileges;

1.4 删除用户

方式 1：使用 drop 方式删除（推荐）
使用 drop user 语句来删除用户时，必须拥有 drop user 权限。drop user 语句的基本语法形式如下：
drop user user[,user]…;

# 删除 li4 用户
drop user li4 ; # 默认删除 host 为 % 的用户

方式 2：使用 delete 方式删除

执行完 delete 命令后要使用 flush 命令来使用户生效，命令如下：
delete from mysql.user where host=’hostname’ and user=’username’;
flush privileges;

# 删除 zhang3 用户
create user 'zhang3'@'localhost' identified by '123456';
delete from mysql.user where host='localhost' and user='zhang3';
flush privileges;

注意：不推荐通过 delete from user u where user='li4' 进行删除，系统会有残留信息保留。而 drop user 命令会删除用户以及对应的权限，执行命令后你会发现 mysql.user 表和 mysql.db 表的相应记录都消失了。

1.5 设置当前用户密码

有两种方式：

1. 使用 alter user 命令来修改当前用户密码。代码如下：
alter user user() identified by 'new_password';

2. 使用 set 语句来修改当前用户密码。代码如下：
set password = password('new_password');
或者
set password = 'new_password';
该语句会自动将密码加密后再赋给当前用户。

1.6 修改其它用户密码

1. 使用 alter 语句来修改普通用户的密码。代码如下：
alter user user_name1 [identified by 'new_password'][, user_name2 [identified by 'new_password']]…;

2. 使用 set 命令来修改普通用户的密码。代码如下：
set password for 'username'@'hostname'='new_password';

3. 使用 update 语句修改普通用户的密码（不推荐）
update mysql.user set authentication_string=password("123456")
where user = "username" and host = "hostname";

2. 权限管理

2.1 权限列表

MySQL 到底都有哪些权限呢？

show privileges;

2.2 授予权限的原则

权限控制主要是出于安全因素，需要遵循以下几个原则 ：

1、只授予能满足需要的最小权限，防止用户干坏事。比如用户只是需要查询，那就只给 select 权限就可以了，不要给用户赋予 update、insert 或者 delete 权限。
2、创建用户的时候，限制用户的登录主机，一般是限制成指定 IP 或者内网 IP 段。
3、为每个用户设置满足密码复杂度的密码。
4、定期清理不需要的用户，回收权限、删除或锁定用户。

2.3 授予权限
grant pv1, pv2, …, pvn on db_name.tb_name to user_name@hostname [identified by ‘new_password’];

该权限如果发现没有该用户，则会直接新建一个用户。

比如：

# 给 li4 用户用本地命令行方式，授予 northwind 这个库下的所有表的插删改查的权限
grant select, insert, delete, update on northwind.* to li4@localhost ;

# 授予 joe 用户，对所有库所有表的全部权限，密码设为 123。注意这里唯独不包括 grant 的权限
grant all privileges on *.* to joe@'%' identified by '123';

我们在开发应用时，需要根据不同用户，在两个维度上进行权限设置
- 指定用户可以接触到的数据范围，比如：可以看到哪些表的数据
- 指定用户对接触到的数据能访问到什么程度，比如：查看、增加、修改、删除

2.4 查看权限

查看当前用户权限
show grants;
或者
show grants for current_user;
或者
show grants for current_user();

查看某用户的权限
show grants for 'wangding'@'%';

2.5 收回权限

注意：在将用户账户从 user 表删除之前，应该收回相应用户的所有权限。

收回权限命令
revoke 权限1, 权限2, …, 权限n on db_name.tb_name from user@hostname;

show grants for 'abc'@'%';
select * from mysql.user where user = 'abc'\G
grant select on northwind.* to abc;
revoke all privileges, grant option from 'abc'@'%';
grant all on *.* to 'abc'@'%' with grant option;

举例

# 收回 joe 用户的所有权限
revoke all privileges on *.* from joe@'%';

# 收回 zhang3 库在 MySQL 库下的所有表的增、删、改、查权限
revoke select, insert, update, delete on mysql.* from zhang3@%;

注意：用户重新登录后才能生效

3. 权限表

3.1 user 表

user 表是 MySQL 中最重要的一个权限表，记录用户账号和权限信息 ，有 49 个字段。

desc mysql.user;

select * from mysql.user;

select host, user, authentication_string, select_priv, insert_priv, drop_priv
from mysql.user;

3.2 db 表

desc mysql.db;

select * from mysql.db;

3.3 tables_priv 表和 columns_priv 表

desc mysql.tables_priv;

select * from mysql.tables_priv;

desc mysql.columns_priv;

select * from mysql.columns_priv;

3.4 procs_priv 表

desc mysql.procs_priv;

select * from mysql.procs_priv;
