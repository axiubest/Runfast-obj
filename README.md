# Runfast-obj------天天爱跑源码
 ![image](https://github.com/axiubest/Runfast-obj/blob/master/%E6%9C%AA%E6%A0%87%E9%A2%98-1.png)
 
 ##  BLE开发项目功能点介绍
 * 启动页
 * 首页
 * 蓝牙连接列表
 * 我的（世界排名，运动目标，历史记录，更多设置，帮助，退出）
 * 历史记录
 * 模式选择（时间模式，卡路里模式，公里模式）
 * 跑步控制界面
 * 跑步结束界面（保存，分享）

### 首页
首页的UI布局由一个仪表盘组成，外层显示公里数，内层显示时间天数，目标设置可在：我的——运动目标，设置。下方两个按钮条转到历史记录和模式选择两个模块中。蓝牙中心控制者SerialGATT服务保持在首页即MainPageViewController控制器中，由此控制器传值到蓝牙列表，跑步机控制界面。

### 蓝牙连接列表
由MainPageViewController将蓝牙设备数组peripheralViewControllerArray，传递到次中。list展示。点击cell携参回调回首页执行开始跑步。

### 跑步控制界面
由MainPageViewController将蓝牙服务SerialGATT *sensor传递到BLEViewController控制器中，经过软硬件双方校验后将正确的蓝牙数据包内容分隔显示到指定label中展示。（具体校验方法下方有做说明）

### 模式选择
模式选择分为时间，卡路里，公里模式，三种模式选择完成后，通过通知中心传递到蓝牙控制界面中，在数据接收中进行判断，如果匹配，则以label的形式显示

### 运动目标
运动目标分为7日目标， 30日目标，目标设置完成通过NSUserDefult保存在plist文件中做数据持久化。
