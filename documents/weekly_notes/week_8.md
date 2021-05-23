# 第八周

本周的主题是增加节点移除策略计算不同的resilience，以及graphlet计数。

## 增加节点移除策略

```c++
void analyze_fragmentation(PGraph G, int organism, bool simple_output,
        TIntFltH &NIdDegH, TIntFltH &NIdBtwH, TIntFltH &NIdCloH) {
    TIntFltH NIdRndH;
    system(("mkdir -p " + ROOT_DIR + "/" + FRAGMENT_DIR + "/" + to_string( organism )).c_str());
    system(("mkdir -p " + ROOT_DIR + "/" + FRAGMENT_DIR + "/" + to_string( organism ) + "/random").c_str());

    TRnd random(0); // 0 means seed from clock
    for (int iteration_num=0; iteration_num<1000; iteration_num++) {
        for (PGraph::TObj::TNodeI NI = G->BegNI(); NI < G->EndNI(); NI++) {
            NIdRndH.AddDat(NI.GetId(), random.GetUniDev());
        }
        node_removal(G, organism, "random_" + to_string(iteration_num) , simple_output, NIdRndH); // remove random
    }
    node_removal(G, organism, "degreecentrality", simple_output, NIdDegH);
    node_removal(G, organism, "betweenness", simple_output, NIdBtwH); 
    node_removal(G, organism, "closeness", simple_output, NIdCloH); 
}
```

首先，上周计算resilience存在一个问题，那就是只把一次随机移除节点策略得到的fragmentation用于计算。这显然是错误的：随机次数太少了，必须增加次数取平均值。于是，在节点移除策略的随机部分中，通过for循环进行了1000次随机移除节点，并将fragmentation结果写入文件。

此外，除了之前就有的根据度中心性移除节点策略外，还增加了根据betweenness和closeness来移除节点。

于是计算resilience的代码也要做调整：

```c++
int main() {
    system(("mkdir -p " + OUTPUT_DIR).c_str());

    vector<string> jobs = GetJobList();

    int jobs_num = jobs.size();
    for (int i=0; i<jobs_num; i++) {
        string species_id = jobs[i];
        cout << "# (" << i << "/" << jobs_num << ") " << species_id << endl;

        AllStrategiesResilience asr = GetAllStrategiesResilience(species_id); 

        double random_sum = 0.0;
        double random_avg = 0.0;

        for (vector<double>::iterator it=asr.randoms.begin(); it!=asr.randoms.end(); it++) {
            random_sum += *it;
        }
        random_avg = random_sum / RANDOM_COUNT;

        string output_path = OUTPUT_DIR + "/" + species_id;
        ofstream out(output_path.c_str());
        out << random_avg << endl
            << asr.betweenness << endl 
            << asr.closeness << endl 
            << asr.degreecentrality << endl;
    }
    return 0;
}
```

从main()中可以看出，对每个物种一共计算了4种resilience：随机、betweenness、closeness、degreecentrality。

## graphlet计数

### 什么是graphlet？

Graphlets是对motif的扩展，motif是从全局的角度来描述图的，全局的图有哪些motif，而Graphlet是从局部(节点)的角度出发来描述，关注这个节点和它邻居的情况，利用局部信息来对每个节点表示。

如下图所示，为n=2,3,4时的graphlets，其中编号代表第几类节点。比如说，当n=2时，有1个graphlets，只有一类节点0，两个节点是同构的。n=3时，有两个graphlets，对应三种节点， ![[公式]](https://www.zhihu.com/equation?tex=G_1) 中有节点1，2，最下面的节点等价于节点1，在图 ![[公式]](https://www.zhihu.com/equation?tex=G_2) 中三个节点都是等价的。n=4时，有6个graphlets，11种节点，比如在 ![[公式]](https://www.zhihu.com/equation?tex=G_4) 中有两类节点，节点7有三个邻居，而剩余三个节点同构，都可认为是节点6。可以看出Graphlet也是一种子图，但是更关注局部节点的性质。

![](https://pic4.zhimg.com/80/v2-9e35603bb7842aeddd2c5d5f6e55727b_1440w.jpg)

### 代码实现计算

本课题使用开源实现[orca](https://github.com/thocevar/orca)来计算，将源码编译成可执行文件，然后根据格式调用即可实现n=4或n=5时的graphlet情况。

```c++
void run_orca(int organism, int graphlet_size, bool simple_output) {
    // Use local executable for local runs
    string orca_exec = simple_output ? "./orca" : ORCA_EXEC_LOCATION;

    string command = orca_exec + " "
        + to_string((long long)graphlet_size) + " "
        + get_output_path(ORCA_FILE_DIR, organism, simple_output) + " "
        + get_output_path(ORCA_STAT_DIR, organism, simple_output) + "-temp > "
        + get_output_path(ORCA_LOG_DIR, organism, simple_output);
    system(command.c_str());

    // Remove edge list file
    string file_path = get_output_path(ORCA_FILE_DIR, organism, simple_output);
    system(("rm " + file_path).c_str());

    // Remove log file for local runs
    if (simple_output) {
        string log_path = get_output_path(ORCA_LOG_DIR, organism, simple_output);
        system(("rm " + log_path).c_str());
    }
}
```

这是调用orca可执行程序的代码，将统计结果保存到本地文件，如下：

NGR_c26960 3 3 2 1 8 3 1 0 0 0 3 1 0 0 0
NGR_c32280 3 4 2 1 10 5 1 0 0 0 3 1 0 0 0
NGR_c36130 1 2 0 0 3 0 0 0 0 1 0 0 0 0 0
NGR_c02150 2 8 1 0 7 4 5 0 2 11 0 0 0 0 0

