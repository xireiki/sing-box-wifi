#!/system/bin/sh

mode="ips"
# iw / jq / ips
# default ips

info(){
  printf "INFO $@"
}

warn(){
  printf "WARN $@"
}

error(){
  printf "ERRO $@"
}

iwmode(){
  lastSSID=""
  lastAuthorizationKey=""
  info "iw 模式\n"
  while true; do
    if [[ ! -e "$MODDIR/disable" ]]; then
      SSID=`${MODDIR}/bin/iw wlan0 link | awk '/SSID/{print $2;exit}'`
      if [ "$SSID" != "$lastSSID" ]; then
        authorizationKey="$(awk '/authorizationKey/{l=length($2);if(substr($2, 0, 1) == "\"" && substr($2, l - 1, 1)){print substr($2, 2, l - 2)}else{print $2}}' /data/adb/sfm/src/config.hjson)"
        if [ -n "$authorizationKey" ]; then
          if [ "$lastAuthorizationKey" != "$authorizationKey" ]; then
            info "找到咒语: $authorizationKey 喵\n"
            lastAuthorizationKey=$authorizationKey
          fi
        else
          error "找不到神秘咒语，请确认安装神秘 喵\n"
          exit
        fi
        status=`curl "http://localhost:23333/api/kernel" -H "authorization: $authorizationKey" -H "Content-Type: application/json" 2> /dev/null | awk -F \" '/status/{print $4}'`
        if [ "$status" = "working" ]; then
          if [ -n "$SSID" ]; then
            info "你已连接到 WI-FI: $SSID，正在关闭 singBox\n"
            con=`curl "http://localhost:23333/api/kernel" -H "authorization: $authorizationKey" -H "Content-Type: application/json" -d '{"method":"stop"}' 2> /dev/null`
            if [ -n "$con" ]; then
              info "神秘不唱了 喵\n"
            else
              error "请检查神秘状态，它可能不在运行 喵\n"
            fi
          else
            warn "你未连接到 WI-FI，singBox 正在运行\n"
          fi
        elif [ "$status" = "stopped" ]; then
          if [ -n "$SSID" ]; then
            warn "你已连接到 WI-FI: $SSID，singBox 不在运行\n"
          else
            con=`curl "http://localhost:23333/api/kernel" -H "authorization: $authorizationKey" -H "Content-Type: application/json" -d '{"method":"start"}' 2> /dev/null`
            info "你未连接到 WI-FI，正在启动 singBox\n"
            if [ -n "$con" ]; then
              info "神秘开唱了 喵\n"
            else
              error "请检查神秘状态，它可能不在运行 喵\n"
            fi
          fi
        else
          warn "神秘正在切换状态($status)，请耐心等待...\n"
        fi
      fi
      lastSSID=$SSID
    fi
    sleep 1
  done
}

jqmode(){
  lastStatus=""
  info "jq 模式\n"
  while true; do
    if [[ ! -e "${MODDIR}/disable" && -x "/data/data/com.termux/files/usr/bin/jq" ]]; then
      ips=$(/data/data/com.termux/files/usr/bin/ip -j address show wlan0 | ${MODDIR}/bin/jq .[].addr_info)
      if [ "$ips" != "$lastStatus" ]; then
        authorizationKey="$(awk '/authorizationKey/{l=length($2);if(substr($2, 0, 1) == "\"" && substr($2, l - 1, 1)){print substr($2, 2, l - 2)}else{print $2}}' /data/adb/sfm/src/config.hjson)"
        if [ -n "$authorizationKey" ]; then
          if [ "$lastAuthorizationKey" != "$authorizationKey" ]; then
            info "找到咒语: $authorizationKey 喵\n"
            lastAuthorizationKey=$authorizationKey
          fi
        else
          error "找不到神秘咒语，请确认安装神秘 喵\n"
          exit
        fi
        status=`curl "http://localhost:23333/api/kernel" -H "authorization: $authorizationKey" -H "Content-Type: application/json" 2> /dev/null | awk -F \" '/status/{print $4}'`
        if [[ "$status" == "working" ]]; then
          if [[ "$ips" != "[]" ]]; then
            info "你已连接到 WI-FI，正在关闭 singBox\n"
            con=`curl "http://localhost:23333/api/kernel" -H "authorization: $authorizationKey" -H "Content-Type: application/json" -d '{"method":"stop"}' 2> /dev/null`
            if [ -n "$con" ]; then
              info "神秘不唱了 喵\n"
            else
              error "请检查神秘状态，它可能不在运行 喵\n"
            fi
          else
            warn "你未连接到 WI-FI，singBox 正在运行\n"
          fi
        elif [[ "$status" == "stopped" ]]; then
          if [[ "$ips" != "[]" ]]; then
            warn "你已连接到 WI-FI，singBox 不在运行\n"
          else
            con=`curl "http://localhost:23333/api/kernel" -H "authorization: $authorizationKey" -H "Content-Type: application/json" -d '{"method":"start"}' 2> /dev/null`
            info "你未连接到 WI-FI，正在启动 singBox\n"
            if [ -n "$con" ]; then
              info "神秘开唱了 喵\n"
            else
              error "请检查神秘状态，它可能不在运行 喵\n"
            fi
          fi
        else
          warn "神秘正在切换状态($status)，请耐心等待...\n"
        fi
      fi
    fi
    lastStatus="$ips"
    sleep 1
  done
}

ipsmode(){
  lastSize=-1
  info "ips 模式\n"
  while true; do
    if [[ ! -e "$MODDIR/disable" && -x "$MODDIR/bin/ips" ]]; then
      ipnumber="$(${MODDIR}/bin/ips wlan0)"
      if [[ "$ipnumber" != "$lastSize" ]]; then
        authorizationKey="$(awk '/authorizationKey/{l=length($2);if(substr($2, 0, 1) == "\"" && substr($2, l - 1, 1)){print substr($2, 2, l - 2)}else{print $2}}' /data/adb/sfm/src/config.hjson)"
        if [ -n "$authorizationKey" ]; then
          if [ "$lastAuthorizationKey" != "$authorizationKey" ]; then
            info "找到咒语: $authorizationKey 喵\n"
            lastAuthorizationKey=$authorizationKey
          fi
        else
          error "找不到神秘咒语，请确认安装神秘 喵\n"
          exit
        fi
        status=`curl "http://localhost:23333/api/kernel" -H "authorization: $authorizationKey" -H "Content-Type: application/json" 2> /dev/null | awk -F \" '/status/{print $4}'`
        if [[ "$status" == "working" ]]; then
          if [ "$ipnumber" -gt 0 ]; then
            info "你已连接到 WI-FI，正在关闭 singBox\n"
            con=`curl "http://localhost:23333/api/kernel" -H "authorization: $authorizationKey" -H "Content-Type: application/json" -d '{"method":"stop"}' 2> /dev/null`
            if [[ -n "$con" ]]; then
              info "神秘不唱了 喵\n"
            else
              error "请检查神秘状态，它可能不在运行 喵\n"
            fi
          else
            warn "你未连接到 WI-FI，singBox 正在运行\n"
          fi
        elif [[ "$status" == "stopped" ]]; then
          if [ "$ipnumber" -gt 0 ]; then
            warn "你已连接到 WI-FI，singBox 不在运行\n"
          else
            con=`curl "http://localhost:23333/api/kernel" -H "authorization: $authorizationKey" -H "Content-Type: application/json" -d '{"method":"start"}' 2> /dev/null`
            info "你未连接到 WI-FI，正在启动 singBox\n"
            if [[ -n "$con" ]]; then
              info "神秘开唱了 喵\n"
            else
              error "请检查神秘状态，它可能不在运行 喵\n"
            fi
          fi
        else
          warn "神秘正在切换状态($status)，请耐心等待...\n"
        fi
        lastSize="${ipnumber}"
      fi
    fi
    sleep 1
  done
}

if [[ -z "${MODDIR}" ]]; then
  MODDIR="${0%/*}"
fi

case $mode in
  iw)
    iwmode;;
  jq)
    jqmode;;
  ips)
    ipsmode;;
  *)
    error "未知模式，请重新配置\n";;
esac