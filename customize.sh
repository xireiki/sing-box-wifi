abort_install(){
  abort "- INSTALLATION FAILED"
}

if [ "${ARCH}" != "arm64" ] ; then
  ui_print "- 不支持的架构，本模块只支持 arm64 架构的设备"
  abort_install
fi

ui_print "- 开始设置环境权限(0777)"
set_perm_recursive "${MODPATH}" 0 0 0777 0777
