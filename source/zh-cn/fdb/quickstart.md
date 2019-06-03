title: 快速启动 
---

** Fusiondb is a simple and powerful federated database engine **

## FusionDB GUI PSequel

- host：FusionDB SQL Server 主机 IP
- user: fdb
- passowrd: 123456
- database: default 

![FusionDB GUI](http://www.fusionlab.cn/zh-cn/fdb/img/psequel-gui.png)

注：使用 Mac 版本进行测试，连接 `Use SSL` 选项不勾选，默认即可，目前还未支持 `Use SSL`模式。

## QuickStart Examples

FusionDB 兼容 PostgreSQL 协议，支持 PostgreSQL 生态的一些可视化 GUI 工具执行 FQL，极大的方便用户快速上手 FusionDB。未来 FusionDB 会支持更多丰富的 SQL 语法。

如下两个简单的例子，让我们来快速认识 FusionDB SQL 语法。

### FusionDB Join Psequel

1. Load HDFS File

```
load 'hdfs://jdp-2:8020/tmp/spark-tpcds-data/store_sales' format parquet AS store_sales;

SELECT * FROM store_sales LIMIT 200;

show tables;
```

2. Load MySQL Table

```
load 'mysql' options('url'='jdbc:mysql://mysql-test1:3306/test','dbtable'='person','user'= 'root','password'='root') AS mysql_t2;

SELECT * FROM mysql_t2;
```

3. Load PostgreSQL table

```
load 'postgresql' options('url'='jdbc:postgresql://pg-server-1:5430/test','dbtable'='person','user'= 'xujiang','password'='123') AS gp_t1;

SELECT * FROM gp_t1;
```

4. MySQL Table Join PostgreSQL Table

```
SELECT * FROM mysql_t2 LEFT JOIN gp_t1 ON mysql_t2.id = gp_t1.id;

SELECT * FROM mysql_t2;
```

5. Save table to HDFS

```
save APPEND gp_t1 TO 'hdfs://jdp-2:8020/tmp/pg_test' format parquet;

save overwrite mysql_t2 TO 'hdfs://jdp-2:8020/tmp/pg_test' FORMAT PARQUET;

load 'hdfs://jdp-2:8020/tmp/pg_test' format parquet AS pg_test;

SELECT * FROM pg_test;
```

注意：选中想要执行的语句，点击运行按钮进行 FQL 的执行。此工具选中多条 FQL 执行时，逗号分隔，不支持执行，由于是第三方工具，目前暂未修复此问题。

### FusionDB Join Pandas

1. Psycopg2 connecting FDB

```
import psycopg2
import pandas as pd
connection = psycopg2.connect(“host=localhost port=5432 dbname=default user=xujiang sslmode=disable”)
df = pd.read_sql(sql=”SELECT * FROM VALUES (1, 1), (1, 2) AS t(a, b);”, con=connection)
df
a b
0 1 1
1 1 2
df = pd.read_sql(sql=”show databases;”, con=connection)
df = pd.read_sql(sql=”show tables;”, con=connection)
```

注: psycopg2 连接时，需要 `sslmode=disable`，因为还未支持，未来版本会支持。

2. Local csv file to parquet

```
df = pd.read_sql(sql=”load ‘file:///data/github/fusiondb/data/csv/‘ format csv options(‘inferSchema’=’true’, ‘header’=’true’) as t1”, con=connection)

df =pd.read_sql(sql=”desc t1”, con=connection)
df = pd.read_sql(sql=”save APPEND T1 TO ‘file:///data/github/fusiondb/data/csv/t1‘ format parquet”, con=connection)
```

2. Load csv file to HDFS parquet

```
df = pd.read_sql(sql=”load ‘file:////data/github/fusiondb/data/userdata2.parquet’ format parquet as c2;”, con=connection)

df = pd.read_sql(sql=”save APPEND T1 TO ‘hdfs://jdp-1:8020/tmp/t1‘ FORMAT PARQUET;”, con=connection)

df =pd.read_sql(sql=”load ‘hdfs://jdp-1:8020/tmp/t1‘ format parquet as t2;”, con=connection)

df =pd.read_sql(sql=”show tables;”, con=connection)

df =pd.read_sql(sql=”desc t2;”, con=connection)
```

3. Load parquet file to MySQL t3

```
df = pd.read_sql(sql=”load ‘file:////data/github/fusiondb/data/userdata2.parquet’ format parquet as c2;”, con=connection)

df = pd.read_sql(sql=”save overwrite c2 TO ‘hdfs://jdp-1:8020/tmp/t1‘ FORMAT PARQUET;”, con=connection)

df = pd.read_sql(sql=”load ‘hdfs://jdp-1:8020/tmp/t1‘ format parquet as h1”, con=connection)

df = pd.read_sql(sql=”select * from h1”, con=connection)
df.head()

df = pd.read_sql(sql=”select current_database();”, con=connection)

df = pd.read_sql(sql=”save h1 to ‘mysql’ options(‘url’=”jdbc:mysql://mysql-server:3306/test”,’dbtable’=’h1,’user’= ‘test’,’password’=’123’);”, con=connection)
```

## FAQ

- 关于 MYSQL，PostgreSQL 驱动：需要自己下载安装到 JDP 的 FusionDB lib 目录下，才可以正常使用。

- 关于支持从 Local 加载数据：这里指的 Local 是 FusionDB SQL Server 安装节点 Linux 本机本地的数据。开发调试时Local模式安装，能做到 Local 到集群的读写操作，生产环境目前不建议如此。

- 关于 FusionDB SQL 语法支持：支持 SQL 99 标准，其他 SQL++ 部分是自己扩展的 SQL 语法，未来功能请关注 roadmap 。

- 关于跨多云协作、查询、分析：在下一个版本 release，目前未测试稳定。

- 关于 `Data Lake` 支持事物，实时、批量写数据： 在下一个版本 release，目前未测试稳定。

- 关于 `Data Lake` 支持批流语法统一，批流数据一致问题： 在下一个版本 release，目前未测试稳定。

