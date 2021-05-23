# 第十一周

本周的主题是完善前端Galaxy页面，将之前计算得到的数据尽量展示出来。

## 前置工作

在他人基础上该框架的代码肯定没那么简单的，先花了许多时间研究项目结构的组织，React组件的生命周期，事件监听的注册处等等。当然还有React怎么用。

## 组件之<PpiDetails/ >

这个组件用来展示蛋白质相互作用网络上每个蛋白质节点信息，包括：

- statistics
  - betweenness
  - closeness
  - clustering
  - degreecentrality
  - curvature
- Graphlet counting

该组件包含子组件。

## 组件之<SpeciesDetail/ >

这个组件用来展示整个网络的信息以及网络对应物种的基本信息，这里不一一枚举。

该组件含有若干个子组件，其中的图标是用Echarts实现的。

## 整个Galaxy页面样式的调整

对整个界面的样式调整，达到比较好的视觉效果。