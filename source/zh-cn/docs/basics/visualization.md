title: 数据展现
---

数据可视化，由一个现代化的企业级商业智能Web应用程序Superset提供服务。

提供丰富的数据可视化集，一个易于使用的界面，用于探索和可视化数据。

高度可定制化数据可视化工具。

推荐的数据库连接软件包：

| database      | pypi package   | SQLAlchemy URI prefix       |
| :--- | :----: | :----: | :----: |
| MySQL    |   pip install mysqlclient   | mysql:// |  
| Postgres | pip install psycopg2  | postgresql+psycopg2:// |  
| Presto    | pip install pyhive  | presto:// |  
| Oracle    | pip install cx_Oracle  | oracle:// |  
| sqlite    | default support  | sqlite:// |  
| Redshift    | pip install sqlalchemy-redshift  | redshift+psycopg2:// |  
| MSSQL    | pip install pymssql  | mssql:// |  
| Impala    | pip install pyhive  | jdbc+hive:// |  
| SparkSQL    | pip install sqlalchemy-redshift  | redshift+psycopg2:// |  
| Greenplum    | pip install psycopg2  | postgresql+psycopg2:// |  
| Athena    | pip install "PyAthenaJDBC>1.0.9"  | awsathena+jdbc:// |  
| Vertica    | pip install sqlalchemy-vertica-python  | vertica+vertica_python:// |  
| ClickHouse    | pip install sqlalchemy-clickhouse  | clickhouse:// |  
| Kylin    | pip install kylinpy  | kylin:// |  

目前JDP Package提供的Superset安装包，默认支持`MySQL`、`Postgres`、`Presto`、`sqlite`、`Impala`、`SparkSQL`、`Greenplum`、`ClickHouse`。

Ambari管理Superset界面提供`Quick Links`，访问Superset databaseview，配置`数据源` -> `数据库`添加ClickHouse DataSource，格式如下：

* ClickHouse
    - 连接地址：clickhouse://admin:admin@clickhouse_host_address:8123/default
    - 用户名：admin    # 默认 JDP 
    - 密码：amdin      # 默认 JDP

> 注：`ClickHouse`集群，默认还提供只读用户`ck/admin`。

* MySQL
    - 连接地址：mysql://user:password@your_mysql_address:3306/database
    - 用户名：user
    - 密码： password

## Screenshots

![](https://camo.githubusercontent.com/82e264ef777ba06e1858766fe3b8817ee108eb7e/687474703a2f2f672e7265636f726469742e636f2f784658537661475574732e676966)

![](https://camo.githubusercontent.com/4991ff37a0005ea4e4267919a52786fda82d2d21/687474703a2f2f672e7265636f726469742e636f2f755a6767594f645235672e676966)

![](https://camo.githubusercontent.com/a389af15ac1e32a3d0fee941b4c62c850b1d583b/687474703a2f2f672e7265636f726469742e636f2f55373046574c704c76682e676966)

