# 演示脏读和不可重复读异常，演示不同的隔离级别

show variables like '%iso%';

```
+-----------------------+------------------+
| Variable_name         | Value            |
+-----------------------+------------------+
| transaction_isolation | READ-UNCOMMITTED |
+-----------------------+------------------+
```

# 开五个终端窗口
# T1 default

# T2
set transaction_isolation = 'read-uncommitted';

# T3
set transaction_isolation = 'read-committed';

# T4
set transaction_isolation = 'repeatable-read';

# T5
set transaction_isolation = 'serializable';

# T1~T5 start transaction

# step1
# T1: update t set val = 150 where id=1; select * from t; 更看到 update
# T2: select * from t; 能看到 update，说明发生脏读
# T3-T4: select * from t; 不能看到 update，顺明没有发生脏读
# T5：select * from t; 被锁住，无法读取

# step2
# T1: commit;
# T2: select * from t; 能看到 update
# T3: select * from t; 能看到 update
# T4: select * from t; 看不到 update 如果能看到 update 则为不可重复读
#     T4 可重复读，相当于给做了快照
# T5：可以读，跟 T4 类似
