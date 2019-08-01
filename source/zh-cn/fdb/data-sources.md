title: Data Sources
---

FusionDB 支持直接访问 Oracle、MySQL、PostgreSQL、Greenplum、SQLServer、DB2、Teradata、ClickHouse、HDFS、S3、ADLS、OSS 中的数据做为数据源，实现跨数据源的融合计算以及复杂的数据分析。

## RDBMS 示例 

* Load MySQL Table

```
load 'mysql' options('url'='jdbc:mysql://mysql-test1:3306/test','dbtable'='person','user'= 'root','password'='root') AS mysql_t2;

SELECT * FROM mysql_t2;
```

* Load PostgreSQL table

```
load 'postgresql' options('url'='jdbc:postgresql://pg-server-1:5430/test','dbtable'='person','user'= 'xujiang','password'='123') AS gp_t1;

SELECT * FROM gp_t1;
```

* MySQL Table Join PostgreSQL Table

```
SELECT * FROM mysql_t2 LEFT JOIN gp_t1 ON mysql_t2.id = gp_t1.id;

SELECT * FROM mysql_t2;
```

* Load datasource in query

```
Case1: query all data

load 'mysql' options('url'='jdbc:mysql://your_hostname:53306/test','dbtable'='t1','user'='root','password'='root') AS mysql_t2;

SELECT * FROM mysql_t2;

Case2: query supports pushdown

load 'mysql' options('url'='jdbc:mysql://your_hostname:53306/test','query'='select * from test.t1 where id=2','user'='root','password'='root') AS mysql_t2;

SELECT * FROM mysql_t2;
```

* Load SQLServer Table 

```
## dbtable parameter

load sqlserver options('url'='jdbc:sqlserver://msql-node16:1433','databaseName'='test','dbtable'='test_all_types','user'='SA','password'='@123.') AS sqlserver_t1;

## query parameter

load sqlserver options('url'='jdbc:sqlserver://msql-node16:1433','database'='test','query'='select * from test_all_types where column_binary is null','user'='SA','password'='@123.') AS sqlserver_t1;

SELECT * FROM sqlserver_t1;
```

`注意`: SQLServer 数据库比较特殊，必须填写 database 或 databaseName 字段，映射为 SQLServer 的 database 名称。和其他数据库区别的地方是 `dbtable` 不能直 `[dbname.tablename]`写法，`dbtable` 只能填写要访问的tablename。如果不填写 `dbtable`，而换成 `query` 参数，则直接写 `select` 语句查询，`select`  查询语句不能带 `databaseName`，只能填写 tablename，如上 query parameter 示例。

* Load db2 table

```
## Case1:

load db2 options('url'='jdbc:db2://192.168.9.2:50000/db2test','dbtable'='db2user.test21','user'= 'db2user','password'='@123') AS db2_t1;

SELECT * FROM db2_t1 LIMIT 1000;

## Case2:

load db2 options('url'='jdbc:db2://192.168.9.2:50000/db2test','dbtable'='test2','user'= 'db2user','password'='@123') AS db2_t1;

SELECT * FROM db2_t1 LIMIT 100;

## Case3:

load db2 options('url'='jdbc:db2://192.168.9.2:50000/db2test','dbtable'='(select * from TEST2)','user'= 'db2user','password'='@123') AS db2_t1;

select * from db2_t1;
```

`注意：` DB2 查询时，当前仅支持 `dbtable`，暂时不支持 query 参数。如果传递 query 参数，会报错：`com.ibm.db2.jcc.am.SqlSyntaxErrorException: DB2 SQL Error: SQLCODE=-20521, SQLSTATE=428HV, SQLERRMC=_;7, DRIVER=4.13.127`。

* Load teradata table 

```
case1: 

load teradata options('url'='jdbc:teradata://192.169.0.11/database=test,CHARSET=UTF8,TMODE=TERA','dbtable'='csv_case_tbl','user'= 'dbc','password'='dbc') AS tera_t1;

case2:

load teradata options('url'='jdbc:teradata://192.169.0.11/database=test,CHARSET=UTF8,TMODE=TERA','query'='select * from csv_case_tbl sample 10','user'= 'dbc','password'='dbc') AS tera_t1;

case3: 

load teradata options('url'='jdbc:teradata://192.169.0.11/database=test,CHARSET=UTF8,TMODE=TERA','query'='select TOP 1000 * from csv_case_tbl','user'= 'dbc','password'='dbc') AS tera_t1;

SELECT * FROM tera_t1;
```

`注意`: Teradata 数据库本身比较特殊，查阅资料发现不支持 `limit` 语法，load 语法中这里的 query 传递的是目标数据库的 SQL 语法，只有 load 到 FusionDB 系统才能统一利用 FQL 进行处理。Teradata 语法的特殊性，导致 load 语法执行时相对耗时，sample 会比 top 语法执行耗时更久，在其他数据库目前未发现此类情况。

* Load Greenplum table 

```
load postgresql options('url'='jdbc:postgresql://192.168.0.3:5432/test','dbtable'='company','user'= 'xujiang','password'='@123') AS green_t1;

load postgresql options('url'='jdbc:postgresql://92.168.0.3:5432/test','query'='select * from company','user'= 'xujiang','password'='@123') AS green_t1;

SELECT * FROM green_t1;
```

* Load Huawei GaussDB table

```
load postgresql options('url'='jdbc:postgresql://182.10.2.4:25308/postgres','dbtable'='test','user'= 'gsdb','password'='gsdb@') AS gauss_t1;

load postgresql options('url'='jdbc:postgresql://182.10.2.4:25308/postgres','query'='select * from test','user'= 'gsdb','password'='gsdb@') AS gauss_t1;

select * from gauss_t1;
```

* Load oracle table 

介绍 dbtable 参数的基本使用，全量加载 Oracle 的 table

```
load oracle options('url'='jdbc:oracle:thin:@//192.27.128.122:49161/xe','dbtable'='sample_500W150C','user'='TEST','password'='@123') AS ora_t1;

SELECT * FROM ora_t1;
```

介绍 dbtable 的一种进阶用法，当前 `Oracle` 数据源还不支持 `query` 参数和下推，只能在 dbtable 中写`子查询`，支持子查询下推，具体示例如下：

```
load oracle options('url'='jdbc:oracle:thin:@//192.27.128.122:49161/xe','dbtable'='(select * from sample_500W150C where rownum < 11)','user'='TEST','password'='@123') AS ora_t1;

SELECT count(*) FROM ora_t1;
```

`问题`：如果填写 `query` 参数，提示错误`Exception message:java.sql.SQLSyntaxErrorException: ORA-00911: invalid character`，影响版本 JDP 3.2 及以下版本。修复于 JDP 3.3+，FusinoDB 0.1.1 版本。

`解决`：绕过的方案 dbtable 中填写括号括起来的子查询即可。其他数据库遇到类似问题亦可使用此种方法解决。

## Data Lake 

* Load table in Data Lake

```
LOAD ‘hdfs://cluster1/usr/test’ FORMAT CSV OPTIONS('header'='true') AS T WHERE A=1 AND B=2;

LOAD ‘adls://usr/test’ FORMAT JSON AS T WHERE A=1 AND B=2;

LOAD ‘s3://usr/test’ FORMAT PARQUET AS T WHERE A=1 AND B=2;

LOAD 'oss://usr/test’ FORMAT PARQUET AS T WHERE A=1 AND B=2;

LOAD ‘file:///usr/test' FORMAT ORC AS T WHERE A=1 AND B=2;
```

* Save table to Data Lake

```
SAVE APPEND T1 TO ‘hdfs://cluster1/usr/a' FORMAT 'ORC' OPTIONS ('hdfs.root'='hdp02:8020')  PARTITION BY COL2;

SAVE OVERWRITE T1 TO ‘s3://usr/a’ FORMAT 'CSV' OPTIONS ('bucket.key'='dkfajsdlfjasdkjf') PARTITION BY COL2;

SAVE IGNORE T1 TO ‘adls://usr/a’ FORMAT 'JSON' OPTIONS ('azure.key'='dkljafsdkfjlas') PARTITION BY COL2;

SAVE IGNORE T1 TO ‘oss://usr/a’ FORMAT 'JSON' OPTIONS ('azure.key'='dkljafsdkfjlas') PARTITION BY COL2;
```

