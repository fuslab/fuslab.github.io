title: 架构概览
---

经过 3.0 ~ 3.2 功能上有个很大的跨度，早期 JDP 定位是一个一体化的流分析平台，不会内置任何存储，但是发现在企业私有化部署时有一些障碍。JDP 自身核心组件会提供兼容云端、本地化运行，内置的开源组件则不会又很深入的改动，仅做一些Bugfix。

JDP 3.2 版本未能支持机器学习负载工作，我们引入Docker、Hadoop 3.1，未来我们会研发自己的 Auto 系列的机器学习算法，在 `FusionDB` 提供使用，机器学习框架支持 Docker 与 YARN 3.x 模式。

### 企业级 Core Data & Core AI 流分析平台

[Enterprise-DataFlow-Platfrom-for-JDP-3.0.pdf](https://drive.google.com/open?id=17YU5rQUmbTp1DfX4K6T5pG6WIjfExBTR)

### 企业级 Core Data && Core AI 流分析平台设计与实现

[Enterprise-AI-Platform-Design-And-Impl-v3.2](https://drive.google.com/open?id=1bdkUDc6myVT6NDZpUO2hQjdUuwNiM0UN)

