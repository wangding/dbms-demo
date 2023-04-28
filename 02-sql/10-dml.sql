# DML

# 准备工作

create database if not exists dml character set 'utf8mb4';

show databases;

create table if not exists dml.emp (
  id int,
  name varchar(15),
  hire_date date,
  salary double(10, 2)
);

desc dml.emp;

select * from dml.emp;

# 1. 添加数据

# 方式一：一条一条的添加数据

# 没有指明添加的字段

#正确的
insert into dml.emp
values (1, 'louying', '1998-10-11', 4400);

#注意：一定要按照声明的字段的先后顺序添加

#错误的
insert into dml.emp
values (2, 3400, '2000-12-21', 'chenxin');

# 指明要添加的字段 （推荐）

insert into dml.emp(id, hire_date, salary, `name`)
values(2, '1999-09-09', 4000, 'naoko');

# 说明：没有进行赋值的 hire_date 的值为 null

insert into dml.emp(id, salary, name)
values(3, 4500, 'wangding');

# 同时插入多条记录 （推荐）

insert into dml.emp(id, name, salary)
values
(4, 'songmeng', 5000),
(5, 'liuming', 5500);

# 方式2：将查询结果插入到表中

select * from dml.emp;

insert into dml.emp(id, name, salary, hire_date)
select employee_id, first_name, salary, hire_date
from northwind.employees
where department_id in (70, 60);

# 查询的字段一定要与添加到的表的字段一一对应

desc dml.emp;
desc northwind.employees;

# 说明：emp 表中要添加数据的字段的长度不能低于 employees 表中查询的字段的长度
# 如果 emp 表中要添加数据的字段的长度低于 employees 表中查询的字段的长度的话，就有添加不成功的风险

# 2. 更新数据 （或修改数据）

# update .... set .... where ...
# 可以实现批量修改数据的

update dml.emp
set hire_date = curdate()
where id = 5;

select * from dml.emp;

# 同时修改一条数据的多个字段

update dml.emp
set hire_date = curdate(), salary = 6000
where id = 4;

# 将表中姓名中包含字符 b 的提薪 10%

update dml.emp
set salary = salary * 1.1
where name like '%b%';

#修改数据时，是可能存在不成功的情况的。（可能是由于约束的影响造成的）

update northwind.employees
set department_id = 15000
where employee_id = 104;

# 3. 删除数据 delete from .... where....

delete from dml.emp
where id = 1;

# 在删除数据时，也有可能因为约束的影响，导致删除失败

delete from northwind.departments
where department_id = 90;

# 小结：DML 操作默认情况下，执行完以后都会自动提交数据
# 如果希望执行完以后不自动提交数据，则需要使用 set autocommit = false

# 4. MySQL8 的新特性：计算列

use dml;

create table tb(
  a int,
  b int,
  c int generated always as (a * b) virtual
);
# 字段 c 即为计算列

insert into tb(a, b)
values(10, 20);

select * from tb;

update tb
set a = 100;

# 5. 综合案例

# 1. 创建数据库 store，验证数据库是否创建成功

create database if not exists store character set 'utf8';

show databases;

# 2. 创建表 books，表结构如下：

create table if not exists store.books(
  id int,
  name varchar(50),
  authors varchar(100),
  price float,
  pubdate year,
  category varchar(100),
  num int
);

desc store.books;

select
  id,
  price,
  pubdate,
  category,
  num,
  name,
  authors
from store.books;

# 3. 向 books 表中插入记录

# 1）不指定字段名称，插入第一条记录

insert into store.books
values(1, '看见', '柴静', 39.8, '2013', 'novel', 13);

# 2）指定所有字段名称，插入第二记录

insert into store.books(id, name, authors, price, pubdate, category, num)
values(2, '我的天才女友', '[意] 埃莱娜·费兰特', 42, '2017', 'joke', 22);

# 3）同时插入多条记录（剩下的所有记录）

insert into store.books(id, name, authors, price, pubdate, category, num)
values
(3, '局外人', '[法] 阿尔贝·加缪', 22, 2010, 'novel', 0),
(4, '步履不停', '[日] 是枝裕和', 36.8, 2017, 'novel', 30),
(5, '法学导论', '[德] 古斯塔夫·拉德布鲁赫', 30, 2001, 'law', 10),
(6, '本草纲目', '李时珍', 30, 1990, 'medicine', 40),
(7, '火影忍者', '[日] 岸本齐史', 88, 1999, 'cartoon', 28);


# 4. 将小说类型的书的价格都增加 5

update store.books
set price = price + 5
where category = 'novel';

# 5. 将局外人图书的价格改为 40，并将类别改为 memoir

update store.books
set price = 40, category = 'memoir'
where name = '局外人';

# 6. 删除库存为 0 的记录

delete from store.books
where num = 0;

# 7. 查找书名中包含火的图书

select *
from store.books
where name like '%火%';

# 8. 统计书名中包含火的书的数量和库存总量

select count(*), sum(num)
from store.books
where name like '%火%';

# 9. 查找 novel 类型的书，按照价格降序排列

select name, category, price
from store.books
where category = 'novel'
order by price desc;

# 10. 查询图书信息，按照库存量降序排列，如果库存量相同的按照 category 升序排列

select num, id, category, name
from store.books
order by num desc, category asc;

# 11. 按照 category 分类统计书的数量

select category, count(*)
from store.books
group by category;

# 12. 按照 category 分类统计书的库存量，显示库存量超过 35 本的

select category, sum(num)
from store.books
group by category
having sum(num) > 35;

# 13. 查询所有图书，每页显示 3 本，显示第二页

select *
from store.books
limit 3, 3;

# 14. 按照 category 分类统计书的库存量，显示库存量最多的

select category, sum(num) sum_num
from store.books
group by category
order by sum_num desc
limit 0, 1;

# 15. 查询作者名称达到 7 个字符的书，不包括里面的空格

select char_length(replace(authors, ' ', ''))
from store.books;

select name, authors
from store.books
where char_length(replace(authors, ' ', '')) >= 7;

# 16、查询书名和类型，其中 category 值为 novel 显示小说，law 显示法律，medicine 显示医药，cartoon 显示卡通，joke 显示笑话

select
  name,
  category,
  case category
    when 'novel' then '小说'
    when 'law' then '法律'
    when 'medicine' then '医药'
    when 'cartoon' then '卡通'
    when 'joke' then '笑话'
    else '其他'
  end as "type"
from store.books;

# 17. 查询书名、库存，其中 num 值超过 30 本的，显示滞销，大于 0 并低于 10 的，显示畅销，为 0 的显示需要无货，其他显示正常

select
  name,
  num,
  case
    when num > 30 then '滞销'
    when num > 0 and num < 10 then '畅销'
    when num = 0 then '无货'
    else '正常'
  end as "state"
from store.books;

# 18. 统计每一种 category 的库存量，并合计总量

select ifnull(category, 'TOTAL') as category, sum(num)
from store.books
group by category with rollup;

# 19. 统计每一种 category 的数量，并合计总量

select ifnull(category, 'TOTAL') as category, count(*)
from store.books
group by category with rollup;

# 20. 统计库存量前三名的图书

select *
from store.books
order by num desc
limit 0, 3;

# 21. 找出最早出版的一本书

select *
from store.books
order by pubdate asc
limit 0, 1;

# 22. 找出 novel 中价格最高的一本书

select *
from store.books
where category = 'novel'
order by price desc
limit 0, 1;

# 23. 找出作者名中字数最多的一本书，不含空格

select *
from store.books
order by char_length(replace(authors, ' ', '')) desc
limit 0, 1;
