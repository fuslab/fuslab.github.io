title: FusionDB
---

## FusionDB 是什么？

FusionDB 是一个开源的分布式数据库引擎，加速多数据源融合。

![FusionDB Architecture](http://www.fusionlab.cn/zh-cn/fdb/img/fusiondb-architecture.png)

## 设计原则

* 简单 & 易用 & FQL for Everyone
* 遵循降低研发成本原则，提供极简的使用方法
* 深入理解企业数据管理的刚性需求，构建最优化分布式数据库系统

## 特性

* FusionDB Supports Many Runtimes
* All in FQL
* 批流统一 & 实时计算
* 标准 JDBC/ODBC 

![](http://www.fusionlab.cn/zh-cn/fdb/img/fusiondb-many-runtime.png)

## 运行查询

* Load Data 

```
LOAD ‘hdfs://cluster1/usr/test’ FORMAT 'CSV' OPTIONS('header'='true') AS T WHERE A=1 AND B=2;

LOAD ‘adls://usr/test’ FORMAT 'JSON' AS T WHERE A=1 AND B=2;

LOAD ‘s3://usr/test’ FORMAT 'PARQUET' AS T WHERE A=1 AND B=2;

LOAD ‘file:///usr/test' FORMAT 'ORC' AS T WHERE A=1 AND B=2;

LOAD MYSQL OPTIONS ('url'='jdbc:mysql:dbserver','dbtable'='default.t1','user'='admin', 'password'='123') AS T1 WHERE A=1 AND B=2;

LOAD postgresql OPTIONS ('url'='jdbc:postgresql:dbserver','dbtable'='default.t1','user'='admin', 'password'='123') AS T1 WHERE A=1 AND B=2;

LOAD clickhouse OPTIONS ('url'='jdbc:clickhouse:dbserver','dbtable'='default.t1','user'='admin', 'password'='123') AS T1 WHERE A=1 AND B=2;
```

* Transformation Data

```
Load Data
---------------

SQL Plus: SQL and Stream SQL + TVF(SQL++)          完全兼容标准 SQL 99 以及扩展的SQL++（Stream SQL）

---------------
Save Data
```

* Save Data

```
SAVE T1 TO ‘file:///usr/a' FORMAT 'PARQUET' PARTITION BY COL2;

SAVE APPEND T1 TO ‘hdfs://cluster1/usr/a' FORMAT 'ORC' OPTIONS ('hdfs.root'='hdp02:8020')  PARTITION BY COL2;

SAVE OVERWRITE T1 TO ‘s3://usr/a’ FORMAT 'CSV' OPTIONS ('bucket.key'='dkfajsdlfjasdkjf') PARTITION BY COL2;

SAVE IGNORE T1 TO ‘ADLS://usr/a’ FORMAT 'JSON' OPTIONS ('azure.key'='dkljafsdkfjlas') PARTITION BY COL2;

SAVE T1 TO MYSQL OPTIONS ('url'='jdbc:mysql:dbserver','dbtable'='default.t1','user'='admin', 'password'='123');

SAVE APPEND T1 TO oracle OPTIONS ('url'='jdbc:oracle:dbserver','dbtable'='ora1.a1','user'='admin', 'password'='123');

SAVE OVERWRITE T1 TO sqlserver OPTIONS ('url'='jdbc:sqlserver:dbserver','dbtable'='ora1.a1','user'='admin', 'password'='123');
```

## 什么样的项目适合用 FusionDB

* 跨数据源融合
* 海量数据加载
* 海量数据分析
* 批流统一引擎
* ...
