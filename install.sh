#!/usr/bin/env bash

# Author : tyn1998

root_path=`pwd`

echo "begin..."

if [ ! -d "${root_path}/code/life_tree/data/input/treeoflife.interactomes" ]; then
    unzip $root_path/datasets/treeoflife.interactomes.zip -d $root_path/code/life_tree/data/input
    rm -rf $root_path/code/life_tree/data/input/__MACOSX
fi

# 代码中读文件时没有.txt后缀，因此先批量把文件名后缀去掉
cd $root_path/code/life_tree/data/input/treeoflife.interactomes
for f in *.txt; do
    mv -- "$f" "${f%.txt}"
done

# 进入life_tree中make
cd $root_path/code/life_tree
make

echo "done!"
