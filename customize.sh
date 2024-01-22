abort_install(){
  abort "- INSTALLATION FAILED"
}

checkCMD(){
  if [ -n "$(command -v cmd)" ]; then
    return 1
  elif [ "$(cmd wifi status >/dev/null 2>&1; echo $?)" != "0" ]; then
    return 2
  fi
  return
}

if [ "${ARCH}" != "arm64" ] ; then
  ui_print "- 不支持的架构，本模块只支持 arm64 架构的设备"
  abort_install
fi

ui_print "- 开始设置环境权限(0755 0755)"
set_perm_recursive "${MODPATH}" 0 0 0755 0755

ui_print "- 开始检查设备 cmd 命令支持"
result=$(checkCMD)
if [ "${result}" = "1" ]; then
  ui_print "- 您的手机不存在 cmd 命令"
  abort_install
elif [ "${result}" = "2" ]; then
  ui_print "- 您手机的 cmd 命令不支持 status 子命令"
  abort_install
fi

ui_print "- 安装完成，请重启手机"
