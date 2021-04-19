# 第四周

本周的主题是如何手动构建C++项目。

## 手动？

人生第一次写C++代码就是在IDE上开始的，因此我从来没想过没有IDE我要怎么跑代码。单个`man.cpp`文件还难不倒我，直接用`gcc main.cpp -o main`就好了，但是有多个源文件呢？

在IDE中，我只要正确包含了头文件，那么我总能顺利把代码跑起来；但是Snap-4.0的源码中，包含头文件时都不用完整的路径，满屏幕都是报错。怎么回事？

于是我认识了`gcc -I<headerFilePath>`可以手动指定头文件搜索路径。于是我认识了Makefile可以把复杂的编译顺序自动化——前提是你能把Makefile写对。

原来IDE干了这么多事！

## GNU make

原理上，当面对多个有层级的C++源代码，你只要能把握好顺序，一个个编译最后链接起来，也能得到你要的可执行程序。可这太麻烦了，写个shell脚本吧，这样可以一劳永逸了吧？这的确可以，但是你不想每次只改动了一个文件就重新把所有源文件都编译一遍，这样太低效了！

你需要的是Makefile，让make根据Makefile去自动化编译项目。它会分析依赖关系，每次只重新编译受影响的源文件——这叫增量编译。

## 我的Makefile

```makefile
SNAP_DIR = ../Snap-4.0
GLIB_CORE_DIR = $(SNAP_DIR)/glib-core
SNAP_CORE_DIR = $(SNAP_DIR)/snap-core
SNAP_ADV_DIR = $(NAP_DIR)/snap-adv
SNAP_EXP_DIR = $(NAP_DIR)/snap-exp

UNAME := $(shell uname)

ifeq ($(UNAME), Linux)
	CXX = g++
	CXXFLAGS += -std=c++0x -Wall
	CXXFLAGS += -O3 -DNDEBUG -fopenmp
	LDFLAGS +=
	LIBS += -lrt -lm

else ifeq ($(UNAME), Darwin)
  # OS X flags
  CXX = g++-10
  CXXFLAGS += -std=c++11 -Wall -Wno-unknown-pragmas
  CXXFLAGS += -O3 -DNDEBUG
  CLANG := $(shell g++ -v 2>&1 | grep clang | cut -d " " -f 2)
  ifneq ($(CLANG), LLVM)
    CXXFLAGS += -fopenmp
    #CXXOPENMP += -fopenmp
  else
    CXXFLAGS += -DNOMP
    CXXOPENMP =
  endif
  LDFLAGS +=
  LIBS +=

endif

ANALYZE = analyze
GRAPHLET = graphlet

BIN_DIR := bin

all : $(addprefix $(BIN_DIR)/,$(ANALYZE) $(GRAPHLET) orca)

# COMPILE

$(BIN_DIR)/$(ANALYZE) : $(ANALYZE).cpp $(SNAP_CORE_DIR)/Snap.o | $(BIN_DIR)
	$(CXX) $(CXXFLAGS) -o $(BIN_DIR)/$(ANALYZE) \
		$(ANALYZE).cpp $(SNAP_CORE_DIR)/Snap.o \
		-I$(SNAP_CORE_DIR) -I$(SNAP_ADV_DIR) -I$(GLIB_CORE_DIR) -I$(SNAP_EXP_DIR) $(LDFLAGS) $(LIBS) \

$(BIN_DIR)/$(GRAPHLET) : $(GRAPHLET).cpp $(SNAP_CORE_DIR)/Snap.o | $(BIN_DIR) 
	$(CXX) $(CXXFLAGS) -o $(BIN_DIR)/$(GRAPHLET) $(GRAPHLET).cpp $(SNAP_CORE_DIR)/Snap.o \
		-I$(SNAP_CORE_DIR) -I$(SNAP_ADV_DIR) -I$(GLIB_CORE_DIR) -I$(SNAP_EXP_DIR) $(LDFLAGS) $(LIBS) \

$(SNAP_CORE_DIR)/Snap.o : 
	make -C $(SNAP_CORE_DIR)

$(BIN_DIR)/orca : orca.cpp | $(BIN_DIR)
	g++ -O2 -std=c++11 -o $(BIN_DIR)/orca orca.cpp

$(BIN_DIR) :
	mkdir $(BIN_DIR)

clean:
	rm -f *.o  $(ANALYZE) $(GRAPHLET)

```

