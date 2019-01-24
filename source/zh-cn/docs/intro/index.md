title: JDP 是什么?
---

**JDP是企业级Core Data & Core AI 流分析平台， JDP全称`JDataFlow Platfrom`**，分析流动中的数据。JDP并不是一个框架，而是一套完整的解决方案，主要包括：

- 基础理念：`JDP` 基于Streaming Analytics Visualization架构。
- 开发工具：`Ambari`，基于Ambari源码扩展，JDP更好的融合Ambari。
- 基础构成：`JDP`核心基于高性能的分布式关系型数据库构建，支撑万亿数据秒级响应能力。
- 核心功能：`JDP`核心Core Data & Core AI：
    + Core Data提供高度可视化的流数据分析，Streaming Analytics to Visualization。
    + Core AI提供分布式系统上的AI能力，Smart Application。

- 基础运维：开箱即用，可视化运维管理系统`Ambari Manager`：
    + 提供核心的服务管理与配置中心功能，保障集群的稳定可靠。
    + 简单高效的管理大规模分布式系统，仅需专注业务应用。

![JDataFlow](http://www.fusionlab.cn/zh-cn/docs/intro/img/JDataFlow-Pratfrom.png)

## 设计原则

- Internet of Things (IoT)，连接一切的时代，数据在流动中被处理。
- 简单易用的 FQL，实现跨数据源融合计算能力。
- JDP流分析平台，简单高性能的数据分析，Core Data遵循分布式系统设计原则。
- 遵循企业现有服务体系。无缝融入现有企业数据中心系统，可直接交互数据。

## 特性

- One-stop solution：开箱即用 & 简单 & 易用。
- 高性能：万亿数据秒级响应，提供PB级数据存储。
- 扩展性：规模化部署，可达几百台集群规模。
- 可视化：可视化的数据收集、数据存储、数据分析、数据报表。
- 可靠性：集群提供副本容错机制，硬件故障不会造成数据丢失。
- 简单运维：日志、监控、报警、配置、服务一栈式管理。
- 简单易用：提供标准SQL，拖拽式数据分析。
- 全流程数据处理：`Load Data -> FQL Analysis -> Save Data`
- FQL for Everyone & All in FQL

## 什么样的项目适合用JDP

目前JDP的定位主要是`流数据处理能力`及`结构数据管理能力`。基于这两大能力，JDP有自己的特定应用场景。主要如下：

- 即席查询
- 海量日志分析
- 实时数据处理
- 离线数据处理
- 数据可视化

