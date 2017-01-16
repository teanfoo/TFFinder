<img src="https://github.com/teanfoo/TFFinder/blob/master/Images/1.png" width="100" height="100">
## TFFinder
* A solution to view computer files on mobile devices.
* 一个在移动设备上查看电脑文档的解决方案。

## Build in
* Mac OS X 10.10
* Xcode 7.3
* iOS 8.0

## 使用
* 第一步：准备
  * 一台安装了“TFFinder”的iOS移动设备（暂时只支持iOS）；	
  * 一台电脑（暂时只支持Mac OS X）；
  * 移动设备和电脑在同一局域网络中（连同一个WiFi或者移动设备连接电脑发出的WiFi热点）
  * 文件表生成器"FileListMaker"（下载地址：<a href="https://github.com/teanfoo/TFFinder/blob/master/TFFileListMaker/FileListMaker.zip">GitHub</a>或者<a href="https://pan.baidu.com/s/1hrZodV2">百度网盘</a>）；
  
* 第二步：在电脑上开启WebServer服务（注：暂时只提供了Mac版的教程，后续会更新。）
  * 在电脑上打开“终端”这个应用：
  <img src="https://github.com/teanfoo/TFFinder/blob/master/Images/2.png">
  * 输入启动命令：sudo apachectl start 然后按回车 >>> 输入电脑的密码后再按回车；这样就开启WebServer服务了。
  * 其他相关指令：
    * ``启动：sudo apachectl start``
    * ``停止：sudo apachectl stop``
    * ``重启：sudo apachectl restart``
    
  * 打开浏览器（Safari），输入网址：127.0.0.1或者输入：localhost按下回车；显示“It works！”就表示开启成功了。如下图：
  <img src="https://github.com/teanfoo/TFFinder/blob/master/Images/3.png" width="600" height="400">

* 第三步：在服务跟路径创建“TFFinder”子路径
  * 在电脑上打开“Finder”应用，按照下图找到对应路径并创建TFFinder文件夹：
  <img src="https://github.com/teanfoo/TFFinder/blob/master/Images/4.png">

* 第四步：配置TFFinder子路径：
  * 把下载的“FileListMaker.zip”解压，然后把文件表生成器“FileListMaker”拷贝到TFFinder路径下，然后随便往里面加入一些测试文件，再双击运行一下“FileListMaker”
  
* 第五步：查看电脑的IP地址：
  * 打开电脑的“系统偏好设置” >>> 选择“网络”，IP地址如下图红色框中所示：
  <img src="https://github.com/teanfoo/TFFinder/blob/master/Images/5.png" width="600" height="500">

* 第六步：连接电脑的WebServer：
  * 在移动设备上启动应用“TFFinder”，在IP输入框中填写电脑的IP地址，如下图：
  <img src="https://github.com/teanfoo/TFFinder/blob/master/Images/6.png" width="360" height="640">
