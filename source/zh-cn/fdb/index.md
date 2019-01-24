title: FusionDB
---

## FusionDB 是什么？

FusionDB 是一个开源的分布式 FQL 数据库引擎，加速多数据源融合。

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
LOAD 'HDFS'.'/usr/test' FORMAT 'CSV' OPTIONS('header'='true') AS T WHERE A=1 AND B=2;

LOAD 'ADLS'.'/usr/test' FORMAT 'JSON' AS T WHERE A=1 AND B=2;

LOAD 'S3'.'/usr/test' FORMAT 'PARQUET' OPTIONS('fs.s3a.access.key'='ACCESS-KEY','fs.s3a.secret.key'='SECRET-KEY','fs.s3a.endpoint'='s3.REGION.amazonaws.com') AS T WHERE A=1 AND B=2;

LOAD 'LOCAL'.'/usr/test' FORMAT 'ORC' AS T WHERE A=1 AND B=2;

LOAD 'MYSQL' OPTIONS ('url'='jdbc:mysql://node1:3306/default','dbtable'='default.t1','user'='admin', 'password'='123') AS T1 WHERE A=1 AND B=2;

LOAD 'HBASE' OPTIONS ('hbase.zookeeper.quorum'='node1:2181,node2:2181,node3:2181','hbase.zookeeper.property.clientPort'='2181','htable'='default.t1') AS T1 WHERE A=1 AND B=2;

LOAD 'Hive' OPTIONS ('hive.metastore.uris'='thrift://<host>:<port>','hive.metastore.warehouse.dir'='/usr/hive/warehouse','fs.default.name'='hdfs:///','user'='hive','password'='123') AS T1 WHERE A=1 AND B=2;
```

* Transformation Data

```
Spark SQL/Stream SQL + TVF(SQL++)    

Create Stream Table t1（
  id int,
  name string,
  createTime date
) with (
  'stype' = 'kafka',
  'ktopic' = 'user',
  'auto.offset.reset' = 'earliest',
  'bootstrap.servers' = 'localhost:9092',
  'group.id' = 'query-consumer-1',
  'enable.auto.commit' = 'true',
  'session.timeout.ms' = '30000',
  ...
)

select * from t1 where createTime > 20180102 as stream_test;

SAVE APPEND stream_test TO 'MYSQL' OPTIONS ('url'='jdbc:mysql://node1:3306/default','dbtable'='default.t1','user'='admin', 'password'='123');
```

* Save Data

```
SAVE T1 TO 'LOCAL'.'/usr/a' FORMAT 'PARQUET' PARTITION BY COL2;

SAVE APPEND T1 TO 'HDFS'.'/usr/a' FORMAT 'ORC' OPTIONS ('hdfs.root'='hdp02:8020')  PARTITION BY COL2;

SAVE OVERWRITE T1 TO 'S3'.'/usr/a' FORMAT 'CSV' OPTIONS ('aws.bucket.key'='dkfajsdlfjasdkjf') PARTITION BY COL2;

SAVE IGNORE T1 TO 'ADLS'.'/usr/a' FORMAT 'JSON' OPTIONS ('azure.key'='dkljafsdkfjlas') PARTITION BY COL2;

SAVE T1 TO 'MYSQL' OPTIONS ('url'='jdbc:mysql://node1:3306/default','dbtable'='default.t1','user'='admin', 'password'='123');

SAVE APPEND T1 TO 'ORACLE' OPTIONS ('url'='jdbc:oracle:thin:@node1:1521:orcl','dbtable'='ora1.a1','user'='admin', 'password'='123');

SAVE OVERWRITE T1 TO 'SQLServer' OPTIONS ('url'='jdbc:microsoft:sqlserver://node1:1433','dbtable'='ora1.a1','user'='admin', 'password'='123');
```

## 什么样的项目适合用FusionDB

* 跨数据源融合
* 海量数据加载
* 海量数据分析
* ...
