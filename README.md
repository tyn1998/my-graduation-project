# 如何克隆该项目
由于该项目使用了`git submodule`，因此可以用以下命令一次性克隆该项目以及包含的子模块：
```
git clone --depth=1 https://hub.fastgit.org/tyn1998/gp.git --recursive
```
其中克隆地址采用镜像地址来加快国内下载速度，--depth=表示只要最近一次提交（减少空间占用）。
