# 第十周

本周的主题是跑通上周提到的[pm](https://github.com/anvaka/pm)。

## 离线计算layout

interactomes --> ngraph.graph --> ngraph.offline.layout --> ngraph.tobinary

### interactomes --> ngraph.graph

```javascript
function createGraph(edgesFile) {
  let graph = ngraph();

  const interactomesStr = fs.readFileSync(edgesFile).toString();
  const interactomesArr = interactomesStr.split("\n");
  interactomesArr.splice(-1, 1); //最后一个元素是空的, 删之

  interactomesArr.forEach((line) => {
    const proteins = line.split(" ");
    graph.addLink(proteins[0], proteins[1]);
  });

  return graph;
}
```

### ngraph.graph --> ngraph.offline.layout --> ngraph.tobinary

```javascript
const options = [
  {
    optionName: "normal",
    layoutOptions: {
      springLength: 30,
      springCoeff: 0.0008,
      gravity: -1.2,
      dragCoeff: 0.02,
      timeStep: 20,
    },
    saveEach: 99999, // 不要保留中间结果
    iterations: 200,
    outDir: null, // 用到时再填写
  },
  {
    optionName: "sparse",
    layoutOptions: {
      springLength: 30,
      springCoeff: 0.0008,
      gravity: -1.2,
      dragCoeff: 0.02,
      timeStep: 100,
    },
    saveEach: 99999,
    iterations: 200,
    outDir: null,
  },
];

function computeAndSaveLayout(graph, option) {
  console.log(
    "Graph parsed. Found " +
      graph.getNodesCount() +
      " nodes and " +
      graph.getLinksCount() +
      " edges"
  );

  var layout = offlineLayout(graph, option);
  console.log("Starting layout. This will take a while...");
  layout.run();
  console.log("Layout completed. Saving to binary format");
  save(graph, { outDir: option.outDir });
  console.log("Saved.");
}
```

## 前端项目梳理

前端使用React.js作为框架，用户的进入页面是welcome.jsx，每个图的入口是一个Destination组件，组件的href属性包含了该图的标识，点击跳转到galaxy页面后会根据这个标识向后端请求对应的图数据（layout等），然后加载完毕后将其渲染在浏览器上。

### 后端的endpoint

```js
// Endpoint of your data
export default {
    dataUrl: '//localhost:9090/'
};
```

### 简易后端

用http-server这个超级精简的http服务器在layout文件夹上跑起来，监听9090端口，前端Destination的href改一下，然后就跑通了，图显示出来了，amazing，还能方向键和鼠标移动。还能点击、搜索节点。