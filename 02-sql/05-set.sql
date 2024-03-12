# 基本查询：集合操作

## 并 union

/*
 * union 合并：将多条查询语句的结果合并成一个结果
 *
 * 语法：
 *       查询语句1
 *       union
 *       查询语句2
 *       union
 *       ...
 *
 * 特点：
 *
 * 1. 要求多条查询语句的查询列数是一致的！
 * 2. 要求多条查询语句的查询的每一列的类型和顺序最好一致
 * 3. union 关键字默认去重，如果使用 union all 可以包含重复项
*/

# 对 set_demo 数据库的 set_a 和 set_b 两个表做并运算，观察查询结果

(select * from set_demo.set_a)
union
(select * from set_demo.set_b);

# union all

(select * from set_demo.set_a)
union all
(select * from set_demo.set_b);

# 用 union 关键字，查询 employees 表中，部门编号大于 90 或邮箱包含 a 的员工信息

select *
from northwind.employees
where email like '%a%' or department_id > 90;

select * from northwind.employees where email like '%a%'
union
select * from northwind.employees where department_id > 90;

## 交 intersect

/*
 * MySQL 8.0.31 版本才支持
*/

# 对 set_demo 数据库的 set_a 和 set_b 两个表做交运算，观察查询结果

(select * from set_demo.set_a)
intersect
(select * from set_demo.set_b);

## 差 except

/*
 * MySQL 8.0.31 版本才支持
*/

# 对 set_demo 数据库的 set_a 和 set_b 两个表做差运算，观察查询结果

(select * from set_demo.set_a)
except
(select * from set_demo.set_b);

## 积 cross join

# 对 set_demo 数据库的 set_a 和 set_c 两个表做积运算，观察查询结果

select * from set_demo.set_a cross join set_demo.set_c;
