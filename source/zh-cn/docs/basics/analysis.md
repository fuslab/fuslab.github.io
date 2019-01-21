title: 数据分析
---

**JDP是企业级Core Data & Core AI 流分析平台， JDP全称`JDataFlow Platfrom`**

## Core Data

`JDP`数据分析核心引擎ClickHouse、ClickStream、CoreEngine。

* CoreEngine - 分布式`Dynamic Data Table`存储引擎。

* ClickStream - 分布式`Dynamic Data`计算引擎。

* ClickHouse - 开源的分布式列式DBMS数据库。

### CoreEngine

CoreEngine动态数据存储引擎，存储实时流动的数据，每一种数据源都拥有唯一schema，在数据存储前经过`Data Collect`进行校验或者简单处理，必须符合schema描述，保障数据质量。

CoreEngine动态数据表，实时数据流转，可供ClickStream实时动态计算，低延迟分析海量数据。

### ClickStream

ClickStream动态计算引擎，分布式实时计算`CoreEngine`中实时流动数据，利用`CoreEngine`提供的Schema，低延迟分析海量数据，提供实时数据服务。

### ClickHouse

ClickHouse开源的分布式列式DBMS数据库，存储结构化数据，高性能的数据响应能力，加速数据业务转化产生商业价值。

由于ClickHouse是自由度非常高的分布式数据库系统，主要体在Table、副本、分片，客户可以任意组合，选择多了，大家都会考虑找最优解，这就造成了使用方面的压力，这也是`JDP`要致力于解决的问题，提供一体化的数据产品，专业的集群管理工具与技术服务。

ClickHouse集群部署模式，主要有以下几种，推荐`B方案`。

* A方案

![clickhouse_no_redundancy](http://www.fusionlab.cn/zh-cn/docs/basics/img/clickhouse-no-redundancy.png)

* B方案

![clickhouse_high_reliability](http://www.fusionlab.cn/zh-cn/docs/basics/img/clickhouse-high-reliability.png)

* C方案

![clickhouse_replication_3](http://www.fusionlab.cn/zh-cn/docs/basics/img/clickhouse-replication-3.png)

目前JDP 3.0默认`A方案`，在云端部署，云存储提供存储可靠性，选择A方案。私有化部署建议`B`方案。`C方案`提供数据3副本，大大提高数据的安全性，需要选择适合的表引擎来保障数据可靠性。

JDP在未来的版本中提供B、C方案，在界面进行选择，目前仅仅支持A方案。

`A`方案最小集群一个node，经过测试1个Node依然可以正常使用。只要随着不断的加节点，达到横向扩展计算和存储能力，由于是新分片，不会对现有数据和业务产生影响。

## Core AI

> 待续。。。
