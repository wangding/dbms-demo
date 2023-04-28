# Data Type

# 1. 整型数据类型

create database if not exists dt;
show databases;

create table dt.tb_int1(
  f1 tinyint,
  f2 smallint,
  f3 mediumint,
  f4 integer,
  f5 bigint
);

desc dt.tb_int1;

insert into dt.tb_int1(f1)
values(12), (-12), (-128), (127);

select * from dt.tb_int1;

# error: out of range

insert into dt.tb_int1(f1)
values(128);

create table dt.tb_int2(
  f1 int,
  f2 int(5),
  f3 int(5) zerofill
);

desc dt.tb_int2;

# 显示宽度为 5。当 insert 的值不足 5 位时，使用 0 填充。
# 当使用 zerofill 时，自动会添加 unsigned

insert into dt.tb_int2(f1, f2)
values(123, 123), (123456, 123456);

select * from dt.tb_int2;

insert into dt.tb_int2(f3)
values(123), (123456);

show create table dt.tb_int2;

create table dt.tb_int3(
  f1 int unsigned
);

desc dt.tb_int3;

insert into dt.tb_int3
values(2412321);

select * from dt.tb_int3;

# error: out of range

insert into dt.tb_int3
values(4294967296);

# 2. 浮点类型

create table dt.tb_double1(
  f1 float,
  f2 float(5, 2),
  f3 double,
  f4 double(5, 2)
);

desc dt.tb_double1;

insert into dt.tb_double1(f1, f2)
values(123.45, 123.45);

select * from dt.tb_double1;

insert into dt.tb_double1(f3, f4)
values(123.45, 123.456); # 存在四舍五入

# error: out of range

insert into dt.tb_double1(f3, f4)
values(123.45, 1234.456);

# error: out of range

insert into dt.tb_double1(f3, f4)
values(123.45, 999.995);

# 测试 float 和 double 的精度问题

create table dt.tb_double2(
  f1 double
);

insert into dt.tb_double2
values(0.47), (0.44), (0.19);

select sum(f1)
from dt.tb_double2;

select sum(f1) = 1.1, 1.1 = 1.1
from dt.tb_double2;

# 3. 定点数类型

create table dt.tb_decimal(
  f1 decimal,
  f2 decimal(5, 2)
);

desc dt.tb_decimal;

insert into dt.tb_decimal(f1)
values(123), (123.45);

select * from dt.tb_decimal;

insert into dt.tb_decimal(f2)
values(999.99);

insert into dt.tb_decimal(f2)
values(67.567);   # 存在四色五入

# error: out of range

insert into dt.tb_decimal(f2)
values(1267.567);

# error: out of range

insert into dt.tb_decimal(f2)
values(999.995);

# 演示 decimal 替换 double，体现精度

alter table dt.tb_double2
modify f1 decimal(5, 2);

desc dt.tb_double2;

select sum(f1)
from dt.tb_double2;

select sum(f1) = 1.1, 1.1 = 1.1
from dt.tb_double2;

# 4. 位类型：bit

create table dt.tb_bit(
  f1 bit,
  f2 bit(5),
  f3 bit(64)
);

desc dt.tb_bit;

insert into dt.tb_bit(f1)
values(0), (1);

select * from dt.tb_bit;

# error: data too long

insert into dt.tb_bit(f1)
values(2);

insert into dt.tb_bit(f2)
values(31);

# error: data too long

insert into dt.tb_bit(f2)
values(32);

select bin(f1), bin(f2), hex(f1), hex(f2)
from dt.tb_bit;

# + 0 以后，以十进制的方式显示数据

select f1 + 0,  f2 + 0
from dt.tb_bit;

# 5.1 year 类型

create table dt.tb_year(
  f1 year,
  f2 year(4)
);

desc dt.tb_year;

insert into dt.tb_year(f1)
values('2021'), (2022);

select * from dt.tb_year;

insert into dt.tb_year(f1)
values ('2155');

# error: out of range

insert into dt.tb_year(f1)
values ('2156');

insert into dt.tb_year(f1)
values ('69'), ('70');

insert into dt.tb_year(f1)
values (0), ('00');

# 5.2 date 类型

create table dt.tb_date(
  f1 date
);

desc dt.tb_date;

insert into dt.tb_date
values ('2020-10-01'), ('20201001'), (20201001);

insert into dt.tb_date
values ('00-01-01'), ('000101'), ('69-10-01'), ('691001'), ('70-01-01'), ('700101'), ('99-01-01'), ('990101');

insert into dt.tb_date
values (000301), (690301), (700301), (990301);

# 存在隐式转换

insert into dt.tb_date
values (curdate()), (current_date()), (now());

select * from dt.tb_date;

# 5.3 time 类型

create table dt.tb_time(
  f1 time
);

desc dt.tb_time;

insert into dt.tb_time
values('2 12:30:29'), ('12:35:29'), ('12:40'), ('2 12:40'), ('1 05'), ('45');

insert into dt.tb_time
values ('123520'), (124011), (1210);

insert into dt.tb_time
values (now()), (current_time()), (curtime());

select * from dt.tb_time;

# 5.4 datetime 类型

create table dt.tb_datetime(
  dt datetime
);

insert into dt.tb_datetime
values ('2021-01-01 06:50:30'), ('20210101065030');

insert into dt.tb_datetime
values ('99-01-01 00:00:00'), ('990101000000'), ('20-01-01 00:00:00'), ('200101000000');

insert into dt.tb_datetime
values (20200101000000), (200101000000), (19990101000000), (990101000000);

insert into dt.tb_datetime
values (current_timestamp()), (now()), (sysdate());

select * from dt.tb_datetime;

# 5.5 timestamp 类型

create table dt.tb_timestamp(
  ts timestamp
);

insert into dt.tb_timestamp
values ('1999-01-01 03:04:50'), ('19990101030405'), ('99-01-01 03:04:05'), ('990101030405');

insert into dt.tb_timestamp
values ('2020@01@01@00@00@00'), ('20@01@01@00@00@00');

insert into dt.tb_timestamp
values (current_timestamp()), (now());

# error: incorrect datetime value

insert into dt.tb_timestamp
values ('2038-01-20 03:14:07');

select * from dt.tb_timestamp;

# 对比 datetime 和 timestamp

create table dt.tb_time(
  d1 datetime,
  d2 timestamp
);

insert into dt.tb_time values('2021-9-2 14:45:52', '2021-9-2 14:45:52');

insert into dt.tb_time values(now(), now());

select * from dt.tb_time;

# 修改当前的时区

set time_zone = '+9:00';

select * from dt.tb_time;

# 6.1 char 类型

create table dt.tb_char(
  c1 char,
  c2 char(5)
);

desc dt.tb_char;

insert into dt.tb_char(c1)
values('a');

# error: data too long

insert into dt.tb_char(c1)
values('ab');

insert into dt.tb_char(c2)
values('ab');

insert into dt.tb_char(c2)
values('hello');

insert into dt.tb_char(c2)
values('王');

insert into dt.tb_char(c2)
values('王顶');

insert into dt.tb_char(c2)
values('软件学院');

# error: data too long

insert into dt.tb_char(c2)
values('河北师范大学软件学院');

select * from dt.tb_char;

select concat(c2, '***')
from dt.tb_char;

insert into dt.tb_char(c2)
values('ab  ');

select char_length(c2)
from dt.tb_char;

# 6.2 varchar 类型

create table dt.tb_varchar1(
  name varchar  # 错误
);

# error: column length too big for column 'name' (max = 21845); use blob or text instead

create table dt.tb_varchar2(
  name varchar(65535)
);

create table dt.tb_varchar3(
  name varchar(5)
);

insert into dt.tb_varchar3
values('王顶'), ('软件学院');

# errror: data too long

insert into dt.tb_varchar3
values('河北师范大学软件学院');

# 6.3 text 类型

create table dt.tb_text(
  tx text
);

insert into dt.tb_text
values('edu2act   ');

select char_length(tx)
from dt.tb_text; # 10

# 6.4 字符集属性：character set 'name'

show variables like 'character_%';

show character set;
show character set like 'utf%';

# 创建数据库时指名字符集

create database if not exists dt character set 'utf8';

show create database dt;

show databases;

# 创建表的时候，指名表的字符集

create table dt.tb_tmp1(
  id int
);

create table dt.tb_tmp2(
  id int
) character set 'utf8mb4';

show create table dt.tb_tmp1;
show create table dt.tb_tmp2;

show tables from dt;

# 创建表，指名表中的字段时，可以指定字段的字符集

create table dt.tb_tmp3(
  id int,
  name varchar(15) character set 'gbk'
);

show create table dt.tb_tmp3;

# 7. enum 类型

create table dt.tb_enum(
  season enum('春', '夏', '秋', '冬')
);

insert into dt.tb_enum
values('春'), ('秋');

select * from dt.tb_enum;

# error: data truncated for column 'season' at row 1

insert into dt.tb_enum
values('春, 秋');

# error: data truncated for column 'season' at row 1

insert into dt.tb_enum
values('人');

insert into dt.tb_enum
values('unknow');

# 可以使用索引进行枚举元素的调用

insert into dt.tb_enum
values(1), ('3');

# 没有限制非空的情况下，可以添加 null 值

insert into dt.tb_enum
values (null);

# 8. set 类型

create table dt.tb_set(
  s set ('a', 'b', 'c')
);

select * from dt.tb_set;
desc dt.tb_set;
show create table dt.tb_set;

insert into dt.tb_set
values ('a'),  ('a,b');

# 插入重复的 set 类型成员时，mysql 会自动删除重复的成员

insert into dt.tb_set (s)
values ('a,b,c,a');

# error

insert into dt.tb_set (s)
values ('a,b,c,d');

create table temp_mul(
  gender enum('男', '女'),
  hobby set('吃饭', '睡觉', '上课', '写代码')
);

insert into temp_mul
values('男', '睡觉, 上课');

select * from temp_mul;

# error: data truncated for column 'gender' at row 1

insert into temp_mul
values('男,女', '睡觉, 上课');

# 9. json 类型

create table dt.tb_json(
  js json
);

insert into dt.tb_json
values ('{"name":"王顶", "age":20, "address":{"province":"河北",  "city":"石家庄"}}');

select * from dt.tb_json;
show tables from dt;
select
  js -> '$.name' as name,
  js -> '$.age' as age,
  js -> '$.address.province' as province,
  js -> '$.address.city' as city
from dt.tb_json;
