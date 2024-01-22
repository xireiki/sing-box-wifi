## sing-box-wifi 更新日志

### v1.1.3
- 优化 安装逻辑，不支持(cmd wifi status)的设备无法安装，请使用 v1.1.1 并在 Termux 中安装 iproute2
- 优化 内置函数执行神秘面板操作而不是外置调用
- 添加 config.sh 配置文件
- 支持指定 WiFi 关闭而不是所有 WiFi

### v1.1.2
- 优化 错误日志分离
- 优化 安装过程
- 优化 启动逻辑
- 完善 README.md

### v1.1.1
- 修复 Magisk 内模块更新 URL 不正确

### v1.1.0
- 优化 使用动态分配内存优化 ips 命令
- 支持 Magisk 内模块更新
- 添加 安装时架构检测，只支持 arm64
