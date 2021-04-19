# 第三周

本周的主题是SNAP for C++：Standard Network Analysis Platform。

## SNAP是什么？

简言之，它一个C++库，用来计算复杂网络。它也有Python版本。

## 构造一个有向图

```c++
  // create a graph
  PNGraph Graph = TNGraph::New();
  Graph->AddNode(1);
  Graph->AddNode(5);
  Graph->AddNode(32);
  Graph->AddEdge(1,5);
  Graph->AddEdge(5,1);
  Graph->AddEdge(5,32);
```

## 遍历顶点或边

```c++
  // create a directed random graph on 100 nodes and 1k edges
  PNGraph Graph = TSnap::GenRndGnm<PNGraph>(100, 1000);
  // traverse the nodes
  for (TNGraph::TNodeI NI = Graph->BegNI(); NI < Graph->EndNI(); NI++) {
    printf("node id %d with out-degree %d and in-degree %d\n",
      NI.GetId(), NI.GetOutDeg(), NI.GetInDeg());
  }
  // traverse the edges
  for (TNGraph::TEdgeI EI = Graph->BegEI(); EI < Graph->EndEI(); EI++) {
    printf("edge (%d, %d)\n", EI.GetSrcNId(), EI.GetDstNId());
  }
  // we can traverse the edges also like this
  for (TNGraph::TNodeI NI = Graph->BegNI(); NI < Graph->EndNI(); NI++) {
    for (int e = 0; e < NI.GetOutDeg(); e++) {
      printf("edge (%d %d)\n", NI.GetId(), NI.GetOutNId(e));
    }
  }
```

