# 第六周

本周的主题是计算Graph的度量。

## 把每个物种的蛋白质相互作用组变成一个无向图

```c++
// Creates a graph out of the organism's data, where vertices are proteins and edges are interactions
PGraph create_graph(int organism, string input, vector<string> &proteins) {
    string data_path = (input == "") ? get_path(EXTRACTED_DATA_DIR, organism) : input;
    ifstream data(data_path.c_str());
    string line;
    char first_protein[MAX_LENGTH];
    char second_protein[MAX_LENGTH];

    PGraph G = PGraph::TObj::New();
    // We need a map in order to retrieve the correct node for a protein
    unordered_map<string, TInt> protein_to_node;

    while (getline(data, line)) {
        sscanf(line.c_str(), "%[^ ] %s", first_protein, second_protein);

        /* 判断一行交互对的两个顶点是否已经在G中，若不在则加入新顶点 */
        if (protein_to_node.count(first_protein) == 0) {
            protein_to_node[first_protein] = G->AddNode();
            proteins.push_back(first_protein);
        }
        if (protein_to_node.count(second_protein) == 0) {
            protein_to_node[second_protein] = G->AddNode();
            proteins.push_back(second_protein);
        }
        /* 加入边 */
        G->AddEdge(protein_to_node[first_protein], protein_to_node[second_protein]);
    }

    IAssert(G->IsOk());
    return G;
}
```

## 计算哪些度量？

- 介数中心性
- 接近中心性
- 聚类系数
- 节点去率分布
- 度中心性
- 在给定移除策略下的破碎情况
- k-core分布
- ...

### 举例：计算度中心性

```c++
// Analyzes the degree centrality distribution of the graph
void analyze_degreecentrality(PGraph G, int organism, bool simple_output,
        const vector<string> &proteins, TIntFltH &NIdDegH) {
    string output_path = get_output_path(DEGREECTR_DIR, organism, simple_output);
    //ofstream degreecentrality(output_path.c_str(), ios_base::app);
    ofstream degreecentrality(output_path.c_str());

    degreecentrality << fixed << setprecision(PRECISION);

    for (PGraph::TObj::TNodeI NI = G->BegNI(); NI < G->EndNI(); NI++) {
        int NId = NI.GetId();
        double Deg = TSnap::GetDegreeCentr(G, NId);
        NIdDegH.AddDat(NId, Deg);
        degreecentrality << proteins.at(NId) << " "
            << Deg << endl;
    }
}
```

## 成果

得到了许多中间数据，等待着被赋予生物学解释。