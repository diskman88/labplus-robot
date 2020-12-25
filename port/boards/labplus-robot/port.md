掌控桌面机器人移植自掌控板实验箱
相对掌控板硬件改动：
    1、RGB灯改成8个，用作机器人手信息指示
    2、加速度计改为MPU6050
    3、外置CODEC芯片
    4、无触摸按键
    5、无声音传感器
    6、显示屏为中景园1.54 OLED。
    7、超声波为通用接口
    8、增加一路光线输入。
    9、去掉按键A
    * 10、增加顶部按键上的状态指示灯。（废弃）
    11、增加从MCU控制（I2C接口）
    13、增加MMA5983磁力计
    14、增加外置PSRAM。flash改为16M

1、项目创建
    * board下新建labplus-robot文件夹,复制board/mpython-classroom-kit文件到robot。
    * labplus-robot下创建audio文件夹，下面创建子模块esp-adf，项目需要使用esp-adf下的esp-idf。
    * 对esp-adf/esp-idf打上补丁。
    * labplus-robot/modules下加入机器人相关的模块。 
    * 创建makefile-robot.mk文件，编译时，需执行：make -f Makefile-robot.mk release  make -f Makefile-robot.mk clean
    * 添加robot/partitions.csv,robot的分区表重新分配，重新创建一个。
    * 参见编译环境搭建，另行创建一个虚拟环境，robot用的是idf v3.3版本。

2、项目修改
    * 修改Makefile-robot.mk：
        # 修改partitions.csv路径。
        # 修改makefile-robot.mk下v3.3的commit hash值
        # BOARD ?= robot
        # FLASH_SIZE ?= 16MB
        # idf v3.3不需要LDFLAGS += -T esp32.rom.syscalls.ld
        # 去掉5x5 rgb点阵模块及驱动。
        # idf v3.3与v4.0网络协议的编译有些差异
          INC_ESPCOMP += -I$(ESPCOMP)/mbedtls/mbedtls/include/mbedtls
    * main.c中添加heap_caps_add_region()操作。
    * 修改mpconfigboard.h:
        修改板名：#define MICROPY_HW_BOARD_NAME "mpython-desktop-robot"
    * 修改mpconfigboard.mk:
        加入 SDKCONFIG += boards/sdkconfig.spiram
    * robot/modules:
        # 增加robot.py, 控制从MCU。
        # 修改_boot.py中RGBled引脚, 灯数为8。
        # 1.54 oled驱动：
            新增ssd1309驱动
            修改mpython中oled的父类为ssd1309_i2c
            升压电路受控。
    * 1.6寸彩屏驱动（废弃）
        1）modst7789.c放入builtin文件兲，修改makefile加入本文件的编译。
        2）加大应用分区表
        3）mpconfigboard.h加入模块st7789

项目创建完后，编译一下。

3、移植esp-adf
    需解决的问题：
        驱动相关，去了除一些不需要的驱动，micropython已对硬件I2C处理，es8388驱动需做些修改，需解决之前固件中已有es8388.c/h文件冲突
        配置需要的adf components,加入一需要的功能，如dueros、播放、录音、唤醒词。
        链接需要用到的adf库文件。
        配置好idf网络相关库。
    * 创建adf-port文件夹，放置本项目adf移植相关文件
    * 修改Makefile-robot.mk:
        # 修改并在Makefile-robot.mk适当位置加入以下adf makefile
            include $(BOARD_DIR)/adf-port/mpadfenv.mk  # 配置一些环境变量及相关头文件包含。
            include $(BOARD_DIR)/adf-port/mpadflibs.mk # 添加一些adf库
            include $(BOARD_DIR)/adf-port/mpadfobj.mk  # 添加需要编译的idf adf源文件
    * mpconfigboard.mk加入adf配置及psram支持
    * mpconfigboard.h加入adf相关模块

------------------------------------------------------------------
注：
micropython编译环境搭建
1. git clone --recursive https://github.com/labplus-cn/mpython.git
  
2. cd mpython/port
   python3 -m venv build-venv
   source build-venv/bin/activate
   pip install --upgrade pip
   pip install -r ../esp-idf/requirements.txt
   
3. cd ../esp-idf #进入esp-idf子模块文件夹
   ./install.sh

4. cd ../port   
   source $ESPIDF/export.sh
   make mpy-cross # 只需新项目时执行一次。
   make
   
每次打开项目编译时需执行：
   cd mpython/port
   source ../esp-idf/export.sh #也可以放入.portfile中，esp-idf路径在项目esp-idf。
   source build-venv/bin/activate #打开venv虚拟环境。
   make or make release