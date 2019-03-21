title: 数据融合
---
**JDP是企业级Core Data & Core AI 流分析平台， JDP全称`JDataFlow Platform`**

## Core Data

`JDP`数据融合引擎`FusionDB`。

* `Load Data` - 分布式数据加载引擎。

* `Save Data` - 分布式数据存储引擎。

`Load Data` 是 FusionDB 中的数据加载引擎，它将 JDP 平台中提供的 Kafka、HDFS、ClickHouse 与其它系统融合在一起，目的是充当企业数据融合管道，轻松将各种复杂的数据系统相互融合。

需要融合其他业务系统数据到ClickHouse，`Load Data` 提供强大的 FQL 数据处理能力，在数据加载的过程中进行处理，而且兼容 MySQL 协议非常方便易用。

`Save Data`数据分发引擎，数据计算或者流转会在分布式计算引擎中，流转过程中可基于 FQL 进行数据聚合实时反馈业务系统，供实时大屏或监控系统使用。

`Save Data`数据分发引擎，配置数据计算间隔和持久化周期，数据量累计到一定程度，我们会以Batch的方式，每隔一段时间周期性把数据入库到 ClickHouse 集群或其他业务系统，ClickHouse 建议批量导入数据，每次个批次数据集大于10w。

ClickHouse & FusionDB 是整个 JDP 平台的核心，提供分布式数据库功能。此外我们还提供更多的选择，如：你可以通过`Load Data`中数据流转视图功能，将数据从一个系统(例如：RDBMS导入到Kafka)，利用`Save Data`数据存储引擎，将动态计算的结果分发到各个业务系统(例如：Kafka Topic内容到 HDFS File/ClickHouse/RDBMS/etc)

如下列出大多数已支持的连接器。

## Load Data & FQL Analysis & Transferd Data

通过持续集成系统jdp-package大量的重复测试，`Data Processor`的功能在JDP平台全部支持，这一切得益于强大的开源社区力量。

| Processor Type | Versoin | Tags |  Document |
| :--- | :----: | :----: | :----: | :----: |
| Database    | 0.1  | RDBMS,JDBC,HBASE,HIVE,Cassandra,Mongo,ClickHouse |     |     |
| Hadoop    | 0.1     | Seqfinle,HDFS,json,HBASE,flume,parquet |     |
| AWS  | 0.1      | DynamoDB,S3,Kinesis,SQS     |     |     |
| Consume  | 0.1      | WebSocket,AMQP,JMS,Kafka,MQTT,POP3     |     |
| Fetch  | 0.1      | Elasticsearch,FTP,HBaseRow,SQS,TCP     |     |
| logs  | 0.1      | Splunk,Syslog,Text,File    |     |
| MySQL  | 0.1      | MYSQL,HDFS,Hive,Cassandra,Kudu    |     | 
| ExecuteScript  | 0.1 | Python,Jython,lua,js,Ruby,Groovy,Clojure |     |

FusionDB 提供跨数据源的数据融合功能，目前支持FQL，兼容标准的 SQL + StreamSQL，在数据流转过程中可提供强大的数据分析能力，对数据进行复杂的实时或批量计算，计算结果 `Save` 到任意的数据存储系统，可对外提供数据服务。

`FusionDB`提供流数据与Batch数据处理，处理结果可以 `Save` 到 ClickHouse 或者其他数据系统，简单 & 易用的 FQL，计算结果存储到 ClickHouse 或者其它业务系统。

## Core AI

> 待续。。。

