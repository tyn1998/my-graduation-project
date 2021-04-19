# 第二周

本周的主题是数据集。

## 数据集下载来源

数据集来自SNAP下的子项目[life-tree](http://snap.stanford.edu/tree-of-life/data.html)。

## 数据集的一些信息

> 我们收集并重新评估了符合我们要求的蛋白交互对和蛋白质络合物数据。这些数据是通过检索STRING（http://string-db.org）数据库得到的原始数据。
>
>
> 大体上，STRING数据库整合了大量物种的known和predicted蛋白交互数据。其中包含了physical（direct）交互对和functional（indirect）交互对，只要它们是明确的且在生物学上是有意义的。但是在此研究中，正如前面提到的，我们只选用physical交互对。总之，我们使用了以下蛋白交互对数据：
>
> （a）实验支持的：来自生物化学、生物物理和基因学实验的交互对。主要是从The International Molecular Exchange Consortium（IMEx）和The Biological General Repository for Interaction Datasets（BioGRID）的基础蛋白交互对数据库中获取。
>
> （b）专家认证的：由专家维护的交互对。主要是：来自TRANScription FACtor（TRANSFAC）的regulatory 交互对，来自Kyoto Encyclopedia of Genes and Genomes（KEGG）database的metabolic enzyme-coupled交互对，来自the Comprehensive Resource of Mammalian Protein Complexes（CORUM）database的蛋白质络合物。
>
> 上述（a）-（b）提到的数据一起构成了该研究使用的蛋白交互对数据集。该数据集囊括了8762166个蛋白交互对，这些交互对包含了1450633个蛋白，它们来自1840个物种（1539个真细菌（bacteria），111个古细菌（archaea），190个真核生物（eukarya））。下文中的蛋白交互组（interactome）就是由该数据集构建而成。
>
> 这个蛋白交互对数据集有两大优势：
>
> （a）这个数据集的质量有保障，因为我们只使用基于实验或由专家认定的交互对数据。更进一步的说，我们抛弃了那些不能强有力证明是physical 交互对的信息，比如：（i）systematic co-expression analysis，（ii）shared signals across genomes和（iii）automated text-mining of the scientific literature。
>
> （b）这个数据集是物种分明的，因为其中的每个交互对都是只属于某一具体物种的。这意味着该数据集不包含由基于gene orthology和计算预测得到的跨物种传递信息的交互对。也就是说以下情况的数据我们是不要的：（i）computational transfer of interactions between organisms based on gene orthology和（ii）computational transfer of interactions between closely related organisms。

## 数据集内容

核心数据是1840个物种的蛋白质相互作用对，即1840个文本文件。每个文件以该物种在NCBI数据库中的ID命名，比如文件9606代表智人的已知蛋白质相互作用对。文件中每一行记录两个蛋白质，代表一对蛋白质相互作用。

## 我对数据集的理解

数据集记录了物种的蛋白质相互作用组的“边”，我需要将这些边以及顶点信息输入到程序中，将它们转换成与“图”相关的数据结构中，进一步分析或计算。