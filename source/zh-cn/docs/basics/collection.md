title: 数据融合
---
**JDP是企业级Core Data & Core AI 流分析平台， JDP全称`JDataFlow Platfrom`**

## Core Data

`JDP`数据融合引擎`Data Collect`和`Transferd`

* `Data Collect` - 分布式数据融合引擎。

* `Transferd` - 分布式数据分发引擎。

`Data Collect`是JDP平台中包含的一个可视化框架，它将JDP平台中提供的Kafka、ClickHouse与其它系统集成在一起，目的是充当企业数据融合管道，轻松将各种复杂的数据系统相互融合。

需要融合其他业务系统数据到ClickHouse，通过`Data Collect`配置想要提取或者推送的系统信息，运行一个流任务视图，任务视图可提供详细的数据流转监控图，帮助分析数据流量。

`Transferd`数据分发引擎，数据提取或者推送会流转于分布式消息系统Kafka，流转过程中可做一些简单的数据聚合实时反馈业务系统，供实时大屏或监控系统使用。

`Transferd`数据分发引擎，配置数据量累计到一定程度，我们会以Batch的方式，每隔2~10分钟周期性把数据入库到ClickHouse集群，ClickHouse建议批量导入数据，每次个批次数据集大于10w。

ClickHouse是整个JDP平台的核心，提供分布式数据库功能。ClickHouse是默认的，此外我们还提供更多的选择，如：你可以通过`Data Collect`中数据流转视图功能，将数据从一个系统(例如：RDBMS导入到Kafka)和`Transferd`数据分发器，将动态计算结果分发到各个业务系统(例如：Kafka Topic内容到HDFS File/ClickHouse/RDBMS/etc)

如下列出大多数已支持的连接器。

## Data Collect Processor & Transferd

通过持续集成系统jdp-package大量的重复测试，`Data Collect`Processor的功能在JDP平台全部支持，这一切得益于强大的开源社区力量。

| Processor Type | Versoin | Tags |  Document |
| :--- | :----: | :----: | :----: | :----: |
| Database    | 1.2  | RDBMS,JDBC,HBASE,HIVE,Cassandra,Mongo,ClickHouse |     |     |
| Hadoop    | 1.2     | Seqfinle,HDFS,json,HBASE,flume,parquet |     |
| AWS  | 1.2     | DynamoDB,S3,Kinesis,SQS     |     |     |
| Consume  | 1.2     | WebSocket,AMQP,JMS,Kafka,MQTT,POP3     |     |
| Fetch  | 1.2     | Elasticsearch,FTP,HBaseRow,SQS,TCP     |     |
| logs  | 1.2     | Splunk,Syslog,Text,File    |     |
| MySQLCDC  | 1.2     | MYSQL,HDFS,Hive,Cassandra,Kudu    |     | 
| ExecuteScript  | 1.2 | Python,Jython,lua,js,Ruby,Groovy,Clojure |     |

`Data Collect`提供数据融合功能，目前支持界面化拖拽式的数据融合，在数据流转过程中可提供ExecuteScript支持语言，对数据进行简单处理和校验，输送到目的端可直接提供数据服务。

`Transferd`提供流数据与Batch数据分发到ClickHouse或者其他数据系统，简单方便的`Policy engine`，加速数据载入ClickHouse或者其他业务系统时间。

## Core AI

> 待续。。。

