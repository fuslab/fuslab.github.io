title: 数据应用
---

**JDP是企业级Core Data & Core AI 流分析平台， JDP全称`JDataFlow Platform`**

JDP平台强大的`Data Pipline`和`Visualization Data`功能，可以支持实时数据分析。

接下来，我们通过一个简单的示例，帮助你入门JDP流分析平台。

## TailFile To ClickHouse

我们通过在集群中任意节点监控`/var/log/insert.log`文件变化，实时获取最新数据入库到`ClickHouse`，并且通过`Superset`做实时数据可视化。

在[数据融合](http://www.fusionlab.cn/zh-cn/docs/basics/collection.html)内容，我们有列表支持的数据源，如下是基础的监控文件功能，同步数据。

### [1] 实时数据流程

![dataflow_tailfile](http://www.fusionlab.cn/zh-cn/docs/basics/img/dataflow-tailfile.png)

如图，我们配置Data Process `TailFile`，实时监控`/var/log/insert.log`文件，同步新增数据，经过`SplitText`设置规则按行分割，通过`PublishKafka`写入kafka的一个Topic中，Topic Name是`t`。

另起一个新流程，通过`ConsumeKafka`实时获取变更数据，通过`InvokeHTTP`发送`POST`请求，写入最新的数据到`ClickHouse`。

如果一次生成`100w`数据写，经过测试，入库非常缓慢，甚至有数据丢失，这是clickhouse不建议的入库方式。最佳选择是通过Batch方式每次10w以上入库。通过上面的方式会每条数据产生一次`POST`,造成底层大量小文件生成。

如果在入库中间增加一个`Data Merge`流程，整体性能会好很多，如果希望clickhouse直接实时入库数据，实时查询，那么建议在底层`Merge Tree`引擎表基础上，建立`Buffer`引擎表，通过Buffer引擎表缓冲，最后才落盘到`Merge Tree`引擎表，类似：

创建源表：

```
create table t (gmt  Date, id UInt16, name String, point UInt16) ENGINE=MergeTree(gmt, (id, name), 10);
```

创建Buffer表：

```
create table t_buffer as t ENGINE=Buffer(default, t, 16, 3, 20, 2, 10, 1, 10000)
```

Buffer 引擎，像是 Memory 存储的一个上层应用似的（磁盘上也是没有相应目录的）。它的行为是一个缓冲区，写入的数据先被放在缓冲区，达到一个阈值后，这些数据会自动被写到指定的另一个表中。

目前ClickHouse引擎是一种默认选择，也可支持其他DBMS/NoSQL入库，我们希望通过一个简单的示例，帮助你快速搭建基于JDP流分析平台。

甚至你可以扩展JDP平台中实时数据接入模块功能，实时可视化配置实时数据到更多系统。

目前已支持主流数据系统，可在[数据融合](http://www.fusionlab.cn/zh-cn/docs/basics/collection.html)和[数据展现](http://www.fusionlab.cn/zh-cn/docs/basics/visualization.html)章节查看。

### [2] 实时数据生成

通过`InsertDataFile.py`程序写入数据到`/var/log/insert.log`文件，每次控制写入数据条数，通过输入参数控制。

例如：

```
python InsertDataFile.py 10
```

`/var/log/insert.log`文件中写入`10`条数据。

样本:

```
(0, '王玉', now(), CAST(now() AS Date))
(1, '王玉立', now(), CAST(now() AS Date))
(2, '金军玲', now(), CAST(now() AS Date))
(3, '李龙玲', now(), CAST(now() AS Date))
(4, '金芳国', now(), CAST(now() AS Date))
(5, '李龙', now(), CAST(now() AS Date))
```

通过组装`query=INSERT INTO t VALUES (5, '李龙', now(), CAST(now() AS Date))`语句发送到ClickHouse执行，如果`CDCMYSQL`需要获取`Insert`或者`Update`导致数据变更的语句发送到ClickHouse或者其他数据库执行，在MYSQLCDC内容进一步介绍。

建表:

```
CREATE TABLE t
(
    id UInt64,
    name String,
    createDate DateTime,
    FlightDate Date
) ENGINE = MergeTree(FlightDate, (id, FlightDate), 8192);
```

如上，数据比较简单，程序自动生成name，id自增，其它字段是通过clickhouse函数生成。

入库:

![](http://www.fusionlab.cn/zh-cn/docs/basics/img/select_t_sample.png)

### [3] 实时数据展现

在`[2]`中我们往`[1]`流程监控的文件中写入`10`条数据，我们通过下图可看到数据变化。

![](http://www.fusionlab.cn/zh-cn/docs/basics/img/clickhouse-superset-datav.gif)

如图，通过`Superset`查询ClickHouse表数据，实时分析总用户数和随机生成用户同名情况分布。

Download [tailfile-to-clickhouse.xml](http://www.fusionlab.cn/zh-cn/docs/basics/img/tailfile-to-clickhouse.xml)

## MySQLCDC To ClickHosue 

**Install MYSQL For CentOS 7.x**

[1] 下载和添加MySQL仓库，然后更新。

```
wget http://repo.mysql.com/mysql-community-release-el7-5.noarch.rpm
sudo rpm -ivh mysql-community-release-el7-5.noarch.rpm
yum update
```

[2] 安装MySQL，然后启动。

```
sudo yum install mysql-server
sudo systemctl start mysqld
```

[3] 初始化MySQL，设置一些基本信息。

```
sudo mysql_secure_installation
```

注意：此处会设置root用户登录密码，请记住它。

[4] 使用MySQL

```
mysql -u root -p
```

[5] MySQL开启binlog

在my.cnf加入以下配置开启binary logging。

```
server_id = 1
log_bin = delta
binlog_format = row
binlog_do_db = source
```

创建数据库和表。

```
create database source;
create database copy;
```

```
mysql> use source;
mysql> CREATE TABLE `users` ( 
`id` mediumint(9) NOT NULL AUTO_INCREMENT PRIMARY KEY, 
`title` text, 
`first` text, 
`last` text, 
`street` text, 
`city` text, 
`state` text, 
`zip` text, 
`gender` text, 
`email` text, 
`username` text, 
`password` text, 
`phone` text, 
`cell` text, 
`ssn` text, 
`date_of_birth` timestamp NULL DEFAULT NULL, 
`reg_date` timestamp NULL DEFAULT NULL, 
`large` text, 
`medium` text, 
`thumbnail` text, 
`version` text, 
`nationality` text) 
ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;
```

为user表插入数据。

```
INSERT INTO `users` (`id`, `title`, `first`, `last`, `street`, `city`, `state`, `zip`, `gender`, `email`, `username`, `password`, `phone`, `cell`, `ssn`, `date_of_birth`, `reg_date`, `large`, `medium`, `thumbnail`, `version`, `nationality`) 
VALUES (1, 'miss', 'marlene', 'shaw', '3450 w belt line rd', 'abilene', 'florida', '31995', 'F', 'marlene.shaw75@example.com', 'goldenpanda70', 'naughty', '(176)-908-6931', '(711)-565-2194', '800-71-1872', '1991-10-07 00:22:53', '2004-01-29 16:19:10', 'http://api.randomuser.me/portraits/women/67.jpg', 'http://api.randomuser.me/portraits/med/women/67.jpg', 'http://api.randomuser.me/portraits/thumb/women/67.jpg', '0.6', 'US'), 
(2, 'ms', 'letitia', 'jordan', '2974 mockingbird hill', 'irvine', 'new jersey', '64361', 'F', 'letitia.jordan64@example.com', 'lazytiger614', 'aaaaa1', '(860)-602-3314', '(724)-685-3472', '548-93-7031', '1977-11-14 11:58:01', '2002-02-09 17:04:59', 'http://api.randomuser.me/portraits/women/19.jpg', 'http://api.randomuser.me/portraits/med/women/19.jpg', 'http://api.randomuser.me/portraits/thumb/women/19.jpg', '0.6', 'US'), 
(3, 'mr', 'todd', 'graham', '5760 spring hill rd', 'garden grove', 'north carolina', '81790', 'M', 'todd.graham39@example.com', 'purplekoala484', 'paintball', '(230)-874-6532', '(186)-529-4912', '362-31-5248', '2006-07-25 05:48:01', '2004-12-05 11:26:34', 'http://api.randomuser.me/portraits/men/39.jpg', 'http://api.randomuser.me/portraits/med/men/39.jpg', 'http://api.randomuser.me/portraits/thumb/men/39.jpg', '0.6', 'US'), 
(4, 'mr', 'seth', 'martinez', '4377 fincher rd', 'chandler', 'south carolina', '73651', 'M', 'seth.martinez82@example.com', 'bigbutterfly149', 'navy', '(122)-782-5822', '(720)-778-8541', '200-80-9087', '1981-02-28 08:22:49', '2009-08-31 12:42:57', 'http://api.randomuser.me/portraits/men/96.jpg', 'http://api.randomuser.me/portraits/med/men/96.jpg', 'http://api.randomuser.me/portraits/thumb/men/96.jpg', '0.6', 'US'), 
(5, 'mr', 'guy', 'mckinney', '4524 hogan st', 'iowa park', 'ohio', '24140', 'M', 'guy.mckinney53@example.com', 'blueduck623', 'office', '(309)-556-7859', '(856)-764-9146', '973-37-9077', '1983-11-03 22:02:12', '2003-10-20 07:23:06', 'http://api.randomuser.me/portraits/men/24.jpg', 'http://api.randomuser.me/portraits/med/men/24.jpg', 'http://api.randomuser.me/portraits/thumb/men/24.jpg', '0.6', 'US'), 
(6, 'ms', 'anna', 'smith', '5047 cackson st', 'rancho cucamonga', 'pennsylvania', '56486', 'F', 'anna.smith74@example.com', 'goldenfish121', 'albion', '(335)-388-7351', '(485)-150-6348', '680-20-6440', '1977-09-05 16:08:05', '2008-07-11 11:09:12', 'http://api.randomuser.me/portraits/women/89.jpg', 'http://api.randomuser.me/portraits/med/women/89.jpg', 'http://api.randomuser.me/portraits/thumb/women/89.jpg', '0.6', 'US'), 
(7, 'mr', 'johnny', 'johnson', '7250 bruce st', 'gresham', 'new mexico', '83973', 'M', 'johnny.johnson73@example.com', 'crazyduck127', 'toast', '(142)-971-3099', '(991)-131-1582', '683-26-4133', '1988-08-12 14:04:27', '2001-04-30 15:32:34', 'http://api.randomuser.me/portraits/men/78.jpg', 'http://api.randomuser.me/portraits/med/men/78.jpg', 'http://api.randomuser.me/portraits/thumb/men/78.jpg', '0.6', 'US'), 
(8, 'mrs', 'robin', 'white', '7882 northaven rd', 'orlando', 'connecticut', '40452', 'F', 'robin.white46@example.com', 'whitetiger371', 'elizabeth', '(311)-659-3812', '(689)-468-6420', '960-70-3399', '2003-07-05 13:09:41', '2014-10-01 02:54:46', 'http://api.randomuser.me/portraits/women/82.jpg', 'http://api.randomuser.me/portraits/med/women/82.jpg', 'http://api.randomuser.me/portraits/thumb/women/82.jpg', '0.6', 'US'), 
(9, 'miss', 'allison', 'williams', '7648 edwards rd', 'edison', 'louisiana', '52040', 'F', 'allison.williams82@example.com', 'beautifulfish354', 'sanfran', '(328)-592-3520', '(550)-172-4018', '164-78-8160', '1983-04-09 08:00:42', '2000-01-01 07:18:54', 'http://api.randomuser.me/portraits/women/16.jpg', 'http://api.randomuser.me/portraits/med/women/16.jpg', 'http://api.randomuser.me/portraits/thumb/women/16.jpg', '0.6', 'US'), 
(10, 'mrs', 'erika', 'king', '1171 depaul dr', 'addison', 'wisconsin', '50082', 'F', 'erika.king55@example.com', 'goldenbutterfly498', 'chill', '(635)-117-5424', '(662)-110-8448', '122-71-7145', '2003-09-19 07:26:17', '2002-12-31 00:08:43', 'http://api.randomuser.me/portraits/women/52.jpg', 'http://api.randomuser.me/portraits/med/women/52.jpg', 'http://api.randomuser.me/portraits/thumb/women/52.jpg', '0.6', 'US');
```

**开始CDC流程**

首先在`NiFi`所在节点，安装MySQL JDBC驱动。

```
yum install mysql-connector-java -y
```

* 流程概述

以下是CDC流程的简要概述：

1. CaptureChangeMySQL读取bin日志以生成FlowFiles（JSON）
2. FlowFiles根据事件类型进行路由：
    - 开始/提交事件：由JoltTransformJSON操纵的JSON
    - DDL事件：添加架构（QUERY）和语句类型（SQL）属性
    - 删除/插入/更新事件：添加表名，模式（USERS）和语句类型属性，操纵JSON
3. EnforceOrder确保所有更改事件按正确顺序处理
4. PutDatabaseRecord使用RecordReader从输入流文件输入多条记录。这些记录被转换为SQL语句并作为一个批处理执行。

* 流程步骤
    
  - 上传模板

    Download [mysqlcdc-to-file.xml](http://www.fusionlab.cn/zh-cn/docs/basics/img/mysqlcdc-to-file.xml)
    
  - 使用和修改模板

    > 修改MySQL驱动的路径 path : /usr/share/java/mysql-connector-java.jar

    > 修改MySQL配置用户名和密码信息。

  - 启动整个workflow。


    整个MySQL-To-File的workflow，实现实时捕获最新MySQL数据变化，并且输出到一个文件或者clickhouse。

![](http://www.fusionlab.cn/zh-cn/docs/basics/img/mysqlcdc-to-file.png)

启动MySQL-To-File整个workflow输出结果如下：

输出13个文件，每个文件代表一个语句：

```
{"type":"ddl","timestamp":1525452754000,"binlog_filename":"delta.000001","binlog_position":220,"database":"source","table_name":null,"table_id":null,"query":"create table `users` ( \n`id` mediumint(9) not null auto_increment primary key, \n`title` text, \n`first` text, \n`last` text, \n`street` text, \n`city` text, \n`state` text, \n`zip` text, \n`gender` text, \n`email` text, \n`username` text, \n`password` text, \n`phone` text, \n`cell` text, \n`ssn` text, \n`date_of_birth` timestamp null default null, \n`reg_date` timestamp null default null, \n`large` text, \n`medium` text, \n`thumbnail` text, \n`version` text, \n`nationality` text) \nengine=innodb auto_increment=1 default charset=latin1"}

{"query":"begin"}

[{"id":1,"title":"miss","first":"marlene","last":"shaw","street":"3450 w belt line rd","city":"abilene","state":"florida","zip":"31995","gender":"F","email":"marlene.shaw75@example.com","username":"goldenpanda70","password":"naughty","phone":"(176)-908-6931","cell":"(711)-565-2194","ssn":"800-71-1872","date_of_birth":"1991-10-07 00:22:53.0","reg_date":"2004-01-29 16:19:10.0","large":"http://api.randomuser.me/portraits/women/67.jpg","medium":"http://api.randomuser.me/portraits/med/women/67.jpg","thumbnail":"http://api.randomuser.me/portraits/thumb/women/67.jpg","version":"0.6","nationality":"US"}]

[{"id":2,"title":"ms","first":"letitia","last":"jordan","street":"2974 mockingbird hill","city":"irvine","state":"new jersey","zip":"64361","gender":"F","email":"letitia.jordan64@example.com","username":"lazytiger614","password":"aaaaa1","phone":"(860)-602-3314","cell":"(724)-685-3472","ssn":"548-93-7031","date_of_birth":"1977-11-14 11:58:01.0","reg_date":"2002-02-09 17:04:59.0","large":"http://api.randomuser.me/portraits/women/19.jpg","medium":"http://api.randomuser.me/portraits/med/women/19.jpg","thumbnail":"http://api.randomuser.me/portraits/thumb/women/19.jpg","version":"0.6","nationality":"US"}]

[{"id":3,"title":"mr","first":"todd","last":"graham","street":"5760 spring hill rd","city":"garden grove","state":"north carolina","zip":"81790","gender":"M","email":"todd.graham39@example.com","username":"purplekoala484","password":"paintball","phone":"(230)-874-6532","cell":"(186)-529-4912","ssn":"362-31-5248","date_of_birth":"2006-07-25 05:48:01.0","reg_date":"2004-12-05 11:26:34.0","large":"http://api.randomuser.me/portraits/men/39.jpg","medium":"http://api.randomuser.me/portraits/med/men/39.jpg","thumbnail":"http://api.randomuser.me/portraits/thumb/men/39.jpg","version":"0.6","nationality":"US"}]

[{"id":4,"title":"mr","first":"seth","last":"martinez","street":"4377 fincher rd","city":"chandler","state":"south carolina","zip":"73651","gender":"M","email":"seth.martinez82@example.com","username":"bigbutterfly149","password":"navy","phone":"(122)-782-5822","cell":"(720)-778-8541","ssn":"200-80-9087","date_of_birth":"1981-02-28 08:22:49.0","reg_date":"2009-08-31 12:42:57.0","large":"http://api.randomuser.me/portraits/men/96.jpg","medium":"http://api.randomuser.me/portraits/med/men/96.jpg","thumbnail":"http://api.randomuser.me/portraits/thumb/men/96.jpg","version":"0.6","nationality":"US"}]

[{"id":5,"title":"mr","first":"guy","last":"mckinney","street":"4524 hogan st","city":"iowa park","state":"ohio","zip":"24140","gender":"M","email":"guy.mckinney53@example.com","username":"blueduck623","password":"office","phone":"(309)-556-7859","cell":"(856)-764-9146","ssn":"973-37-9077","date_of_birth":"1983-11-03 22:02:12.0","reg_date":"2003-10-20 07:23:06.0","large":"http://api.randomuser.me/portraits/men/24.jpg","medium":"http://api.randomuser.me/portraits/med/men/24.jpg","thumbnail":"http://api.randomuser.me/portraits/thumb/men/24.jpg","version":"0.6","nationality":"US"}]

[{"id":6,"title":"ms","first":"anna","last":"smith","street":"5047 cackson st","city":"rancho cucamonga","state":"pennsylvania","zip":"56486","gender":"F","email":"anna.smith74@example.com","username":"goldenfish121","password":"albion","phone":"(335)-388-7351","cell":"(485)-150-6348","ssn":"680-20-6440","date_of_birth":"1977-09-05 16:08:05.0","reg_date":"2008-07-11 11:09:12.0","large":"http://api.randomuser.me/portraits/women/89.jpg","medium":"http://api.randomuser.me/portraits/med/women/89.jpg","thumbnail":"http://api.randomuser.me/portraits/thumb/women/89.jpg","version":"0.6","nationality":"US"}]

[{"id":7,"title":"mr","first":"johnny","last":"johnson","street":"7250 bruce st","city":"gresham","state":"new mexico","zip":"83973","gender":"M","email":"johnny.johnson73@example.com","username":"crazyduck127","password":"toast","phone":"(142)-971-3099","cell":"(991)-131-1582","ssn":"683-26-4133","date_of_birth":"1988-08-12 14:04:27.0","reg_date":"2001-04-30 15:32:34.0","large":"http://api.randomuser.me/portraits/men/78.jpg","medium":"http://api.randomuser.me/portraits/med/men/78.jpg","thumbnail":"http://api.randomuser.me/portraits/thumb/men/78.jpg","version":"0.6","nationality":"US"}]

[{"id":8,"title":"mrs","first":"robin","last":"white","street":"7882 northaven rd","city":"orlando","state":"connecticut","zip":"40452","gender":"F","email":"robin.white46@example.com","username":"whitetiger371","password":"elizabeth","phone":"(311)-659-3812","cell":"(689)-468-6420","ssn":"960-70-3399","date_of_birth":"2003-07-05 13:09:41.0","reg_date":"2014-10-01 02:54:46.0","large":"http://api.randomuser.me/portraits/women/82.jpg","medium":"http://api.randomuser.me/portraits/med/women/82.jpg","thumbnail":"http://api.randomuser.me/portraits/thumb/women/82.jpg","version":"0.6","nationality":"US"}]

[{"id":9,"title":"miss","first":"allison","last":"williams","street":"7648 edwards rd","city":"edison","state":"louisiana","zip":"52040","gender":"F","email":"allison.williams82@example.com","username":"beautifulfish354","password":"sanfran","phone":"(328)-592-3520","cell":"(550)-172-4018","ssn":"164-78-8160","date_of_birth":"1983-04-09 08:00:42.0","reg_date":"2000-01-01 07:18:54.0","large":"http://api.randomuser.me/portraits/women/16.jpg","medium":"http://api.randomuser.me/portraits/med/women/16.jpg","thumbnail":"http://api.randomuser.me/portraits/thumb/women/16.jpg","version":"0.6","nationality":"US"}]

[{"id":10,"title":"mrs","first":"erika","last":"king","street":"1171 depaul dr","city":"addison","state":"wisconsin","zip":"50082","gender":"F","email":"erika.king55@example.com","username":"goldenbutterfly498","password":"chill","phone":"(635)-117-5424","cell":"(662)-110-8448","ssn":"122-71-7145","date_of_birth":"2003-09-19 07:26:17.0","reg_date":"2002-12-31 00:08:43.0","large":"http://api.randomuser.me/portraits/women/52.jpg","medium":"http://api.randomuser.me/portraits/med/women/52.jpg","thumbnail":"http://api.randomuser.me/portraits/thumb/women/52.jpg","version":"0.6","nationality":"US"}]

{"query":"commit"}
```

实时解析MySQL Binlog的输出结果，在整个流程中涉及捕获最新数据变化，根据不同的DML、DDL语句分类放入不同的Process Flow，插入数据转换Json Flow Data。在最后一个Process中合并数据，按照MySQL插入数据顺序，输出结果到一个分布式DB或者文件中。

## Flow Data In Kafka To HDFS

Download [file-to-kakfa-to-hdfs.xml](http://www.fusionlab.cn/zh-cn/docs/basics/img/file-to-kakfa-to-hdfs.xml)

![](http://www.fusionlab.cn/zh-cn/docs/basics/img/47387-kafka-consume-layout.png)

## Other

你可以发挥自己的创造和想象力，通过拖拽式的方式完成企业流数据分析应用。它还可以支持更多数据源和数据分析场景。[快速开启企业级Core Data & Core AI 流分析平台JDP](http://www.fusionlab.cn/zh-cn/docs/intro/quickstart.html)。





