#!/system/bin/sh

MODDIR="${0%/*}"
SingBoxForMagisk="${MODDIR%/*}/SingBox_For_Magisk"
export PATH="/data/adb/magisk:/data/adb/ksu/bin:$PATH:/data/data/com.termux/files/usr/bin"

sleep 15

# 检查神秘状态
node_started(){
  if [ -n "$(netstat -tunlp | grep 23333 | grep node)" ]; then
    return 0
  else
    return 1
  fi
}

# 判断神秘是否禁用，禁用则退出
if [[ -e "${SingBoxForMagisk}/disable" ]]; then
  echo "神秘已禁用，本脚本不启动" > $MODDIR/info.log
  exit
fi

# 等待神秘启动
while true; do
  if node_started; then
    break;
  fi
  sleep 1
done

sleep 5

# 正式启动
if [[ -x "$MODDIR/sing-box-wifi.sh" ]]; then
  $MODDIR/sing-box-wifi.sh  > $MODDIR/info.log 2>$MODDIR/error.log
else
  sh "$MODDIR/sing-box-wifi.sh" > $MODDIR/info.log 2>$MODDIR/error.log
fi
