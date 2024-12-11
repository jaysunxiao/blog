# 一、sql语句

## 1.连接
1. 左连接：left join，如果左表的某行在右表中没有匹配行，则在相关联的结果集行中右表的所有选择列表列均为空值(null)
2. 右连接：right join，如果右表的某行在左表中没有匹配行，则将为左表返回空值
3. 内连接（inner join），如果表中任意一条数据在另一张表中都是找不到对应数据的话，那么在结果表中是不会有这一条数据的。
4. 外链接（outer join），如果某张表中的数据在另一张中找不到对应的条目并不影响它依然出现在查询的结果中，这就有一点数学里的并集的意思

## 2.sql语句慢，从出现的概率由大到小
- SQL编写问题
- 锁，等待表锁或者等待行锁，可以用命令查看状态：show processlist
- 业务实例相互干扰对IO/CPU资源的竞争，如果数据库本身就有很大的压力，导致服务器 CPU 占用率很高或 ioutil（IO 利用率）很高，这种情况下所有语句的执行都有可能变慢。
- 服务器硬件
- 等 flush
- MYSQL BUG


### 1）.sql语句优化案例
```sql
# 假设你现在维护了一个交易系统，其中交易记录表 tradelog 包含交易流水号（tradeid）、交易员 id（operator）、交易时间（t_modified）等字段。
CREATE TABLE `tradelog` (
  `id` int(11) NOT NULL,
  `tradeid` varchar(32) DEFAULT NULL,
  `operator` int(11) DEFAULT NULL,
  `t_modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `tradeid` (`tradeid`),
  KEY `t_modified` (`t_modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```
- 案例一：条件字段函数操作
```
在已经记录了从 2016 年初到 2018 年底的所有数据，运营部门有一个需求是，要统计发生在所有年份中 7 月份的交易记录总数。
select count(*) from tradelog where month(t_modified)=7;

对索引字段做函数操作，可能会破坏索引值的有序性，因此优化器就决定放弃走树搜索功能。优化如下：
select count(*) from tradelog where
(t_modified >= '2016-7-1' and t_modified<'2016-8-1') or
(t_modified >= '2017-7-1' and t_modified<'2017-8-1') or 
(t_modified >= '2018-7-1' and t_modified<'2018-8-1');
```

- 案例二：隐式类型转换
```sql
# 交易编号 tradeid 这个字段上，本来就有索引，但是这条语句需要走全表扫描。因为tradeid 的字段类型是 varchar(32)，而输入的参数却是整型，所以需要做类型转换。
select * from tradelog where tradeid=110717;

# 优化器会做一下优化，也就是说，这条语句触发了我们上面说到的规则：对索引字段做函数操作，优化器会放弃走树搜索功能。
select * from tradelog where  CAST(tradid AS signed int) = 110717;
```

- 案例三：隐式字符编码转换
```

```

## 3.sql优化
```
字段类型转换导致不用索引，如字符串类型不用引号，数字类型用引号等
mysql 不支持函数转换，字段面前不能加函数
不要在字段面前加减运算
字符串比较长的可以考虑索引一部分减少索引文件的大小，提高写入效率
like %在前面用不到索引，需要写在检索关键字的后面
根据联合索引的第二个及以后的字段单独查询用不到索引
不要使用select *
排序尽量使用升序
or的查询尽快用union代替
复合索引高选择性的字段排在前面
order by/group by 字段包括在索引当中减少排序，效率会更高
删除表所有记录用truncate,不要用delete
不要让mysql干多余的事情，例如计算
```