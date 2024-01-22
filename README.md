# sing-box-wifi
本项目是一个用于帮助免流佬自动在 WLAN 下关闭神秘模块的 Magisk 模块（仅限安卓系统），理论支持 KernelSU。

## 警告⚠
因为使用 `cmd wifi status`，所以可能需要较高的安卓版本（MIUI14/android13 测试可用）。

## 使用方法
- 在 [Releases](https://github.com/xireiki/sing-box-wifi/releases) 中下载最新模块
- 在 Magisk 中安装它
- 重启您的安卓手机

## 行为
- 在 /data/adb/modules/SingBox_For_Magisk/disable 存在时（神秘模块禁用时），本模块开机直接退出
- 等待神秘启动
- 在 /data/adb/modules/singBoxWoFi/disable 存在时（本模块禁用时）
  - 开机时不启动
  - 启动后，不执行切换动作

## 更新日志
[CHANGELOG](changelog.md)

## 免责申明
本项目不对以下情况负责：用户使用本模块所造成的一切后果。
