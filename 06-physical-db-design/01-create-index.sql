# 索引

# 一、创建索引

# 1) 建表时创建索引

# 两种方式：
# 隐式创建，在主键约束、唯一性约束、外键约束的字段上，会自动的添加相关的索引

create database idx_demo;
create table idx_demo.dept (
  dept_id int primary key auto_increment,
  dept_name varchar(20) unique
);

show index from idx_demo.dept;

create table idx_demo.emp (
  emp_id int primary key auto_increment,
  emp_name varchar(20),
  dept_id int,
  constraint emp_dept_id_fk foreign key(dept_id) references dept(dept_id)
);

show index from idx_demo.emp;

# 显式创建

# 六种类型

# 1. 普通索引

create table idx_demo.book (
  book_id int ,
  book_name varchar(100),
  authors varchar(100),
  info varchar(100) ,
  `comment` varchar(100),
  year_publication year,
  index idx_bname(book_name)
);

# 方式 1：通过创建表的 SQL 语句查看索引

show create table idx_demo.book;

# 方式 2：查看索引对象

show index from idx_demo.book;

# 2. 唯一索引

# 声明有唯一索引的字段，在添加数据时，要保证唯一性，但是可以添加 null

create table idx_demo.book1 (
  book_id int ,
  book_name varchar(100),
  authors varchar(100),
  info varchar(100) ,
  `comment` varchar(100),
  year_publication year,
  unique index uk_idx_cmt(comment)
);

show index from idx_demo.book1;

# 3. 主键索引

# 通过定义主键约束的方式定义主键索引

create table idx_demo.book2 (
  book_id int,
  book_name varchar(100),
  authors varchar(100),
  info varchar(100) ,
  `comment` varchar(100),
  year_publication year,
  primary key (book_id)
);

show index from idx_demo.book2;

# 4. 单列索引

create table idx_demo.book3 (
  book_id int ,
  book_name varchar(100),
  authors varchar(100),
  info varchar(100) ,
  `comment` varchar(100),
  year_publication year,
  index idx_bname(book_name)
);

show index from idx_demo.book3;

# 5. 联合索引

create table idx_demo.book4 (
  book_id int ,
  book_name varchar(100),
  authors varchar(100),
  info varchar(100) ,
  `comment` varchar(100),
  year_publication year,
  index mul_bid_bname_info(book_id, book_name, info)
);

show index from idx_demo.book4;

# 6. 全文索引

create table idx_demo.ftxt (
  id int not null,
  name char(30) not null,
  age int not null,
  info varchar(255),
  fulltext index futxt_idx_info(info(50))
)

show index from idx_demo.ftxt;

# 2) 建表后创建索引

# 方式 1. alter table table_name add index index_name(field_list);

create table idx_demo.book5 (
  book_id int,
  book_name varchar(100),
  authors varchar(100),
  info varchar(100) ,
  `comment` varchar(100),
  year_publication year
);

show index from idx_demo.book5;

alter table idx_demo.book5 add index idx_cmt(`comment`);
alter table idx_demo.book5 add unique uk_idx_bname(book_name);
alter table idx_demo.book5 add index mul_bid_bname_info(book_id,book_name,info);

# 方式 2. create index index_name on table_name(field_list);

create table idx_demo.book6 (
  book_id int,
  book_name varchar(100),
  authors varchar(100),
  info varchar(100) ,
  `comment` varchar(100),
  year_publication year
);

show index from idx_demo.book6;

create index idx_cmt on idx_demo.book6(`comment`);
create unique index  uk_idx_bname on idx_demo.book6(book_name);
create index mul_bid_bname_info on idx_demo.book6(book_id, book_name, info);

# 二、删除索引

# 通过删除主键约束的方式删除主键索引

show index from idx_demo.book2;

alter table idx_demo.book2
drop primary key;

# 方式1：alter table table_name drop index index_name;

show index from idx_demo.book5;

alter table idx_demo.book5
drop index idx_cmt;

# 方式2：drop index index_name on table_name;

show index from idx_demo.book5;
drop index uk_idx_bname on idx_demo.book5;

# 测试：删除联合索引中的相关字段，索引的变化

alter table idx_demo.book5
drop column book_name;

alter table idx_demo.book5
drop column book_id;

alter table idx_demo.book5
drop column info;

# 三、查看索引

# 方式 1：通过查看建表的语句查看索引

show create table idx_demo.book;

# 方式 2；查看索引对象

show index from idx_demo.book;
