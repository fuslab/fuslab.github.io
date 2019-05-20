title: 数据分析
---

**企业级Core Data & Core AI 统一分析平台， JDP全称`JDataFlow Platform`**

## Core Data

`JDP`数据分析核心引擎FusionDB，一个高性能 & 简单易用真正实现批流统一的分布式数据库引擎。

* FusionDB - 批流统一 & 实时计算，实现跨数据源的融合分析。

* ClickHouse - 开源的分布式列式DBMS数据库。

### Batch

FusionDB 静态数据计算引擎，利用强大 `Data Source Connect` 实现各种数据源的融合计算，每一种数据源都有标准的 Schema 描述，支持动态加载数据到 FusionDB，在 FusionDB 中一切数据都是 Table，任何的数据源都支持 ALL in FQL, 利用 FQL 的强大数据处理能力，实现跨数据源的融合的分析；`FQL for Everyone` 简单 & 易用 & 灵活。

FusionDB 支持简单事件、时序数据处理，拥有强大的海量数据处理能力。

### Stream

FusionDB 动态计算引擎，分布式实时计算`Core Engine`中实时流动的数据，利用`Meta`中提供的 Schema，实现低延迟分析海量数据，提供实时数据服务。

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

## FusionDB

> 待续。。。