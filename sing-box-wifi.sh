#!/system/bin/sh
MODDIR="${0%/*}"
ASH_STANDALONE=1

lang="zh_CN"
# zh_CN / en_US
# default en_US

### Config

# Load Config
source ${MODDIR}/config.sh

# 权限不足
if [ "${lang}" = "zh_CN" ]; then
  PermDeni="权限被拒绝。\n"
  InsuPerm="权限不足，请至少为 SHELL 及以上权限。\n"
  OpenWifi="请打开 WLAN！\n"
else
  PermDeni="Permission denied.\n"
  InsuPerm="Insufficient permission. Please be at least SHELL and above.\n"
  OpenWifi="Please turn on WLAN!\n"
fi

info(){
  printf "INFO $@"
}

warn(){
  printf "WARN $@"
}

error(){
  printf "ERRO $@"
}

UID="$(id -u)"
if [ "${UID}" != 0 -a "${UID}" != 1000 -a "${UID}" != 2000 ]; then
  error "${InsuPerm}"
  exit 1
fi

WLANEnabled(){
  result="$(cmd wifi status | head -n 1 | grep enabled)"
  if [ -n "${result}" ]; then
    return 0
  else
    return 1
  fi
}

getWiFiSSID(){
  if WLANEnabled; then
    SSID="$(cmd wifi status | grep "connected to" | awk '{print $5}' | cut -d '"' -f 2)"
    printf "${SSID}"
    return 0
  else
    error "${OpenWifi}"
    return 1
  fi
}

getSingBoxStatus(){
  status=`curl "http://localhost:23333/api/kernel" -H "authorization: $(awk '/authorizationKey/{l=length($2);if(substr($2, 0, 1) == "\"" && substr($2, l - 1, 1)){print substr($2, 2, l - 2)}else{print $2}}' /data/adb/sfm/src/config.hjson)" -H "Content-Type: application/json" 2> /dev/null | awk -F \" '/status/{print $4}'`
  printf "${status}"
  if [ "${status}" = "working" ]; then
    return 0
  else
    return 1
  fi
}

notify(){
  su shell -c cmd notification post -t "${1}" singBoxWiFi "${2}"
}

singbox(){
  if [ -n "${MODDIR}" -a -x "${MODDIR}/bin/controller" ]; then
    $MODDIR/bin/controller "${1}" > /dev/null
  else
    curl "http://localhost:23333/api/kernel" -H "authorization: $(awk '/authorizationKey/{l=length($2);if(substr($2, 0, 1) == "\"" && substr($2, l - 1, 1)){print substr($2, 2, l - 2)}else{print $2}}' /data/adb/sfm/src/config.hjson)" -H "Content-Type: application/json" -d '{"method": "'${1}'"}' >/dev/null 2>&1
  fi
  return 0
}

while true; do
  if [ -f "${MODDIR}/disable" ]; then
    continue
  fi
  status=$(getSingBoxStatus)
  if [ "${status}" = "working" ]; then
    # 神秘正在工作
    if WLANEnabled; then
      SSID="$(getWiFiSSID)"
      if [ -n "${ActionSSID}" -a "${ActionSSID}" = "${SSID}" ]; then
        notify "模块提示" "你已连接到指定 WiFi: “${SSID}”，正在关闭神秘"
        singbox stop && info "神秘已关闭"
      elif [ -n "${SSID}" -a -z "${ActionSSID}" ]; then
        notify "模块提示" "你已连接到 WiFi “${SSID}”，正在关闭神秘"
        singbox stop && info "神秘已关闭"
      fi
    fi
  elif [ "${status}" = "stopped" ]; then
    if ! WLANEnabled; then
      if [ -n "${ActionSSID}" -a "${ActionSSID}" != "${SSID}" ]; then
        notify "模块提示" "你未连接至指定 WiFi: “${ActionSSID}”，正在启动神秘"
        singbox start && info "神秘已启动"
      fi
      if [ -z "${ActionSSID}" ]; then
        notify "模块提示" "你未连接 WiFi，正在启动神秘"
        singbox start && info "神秘已启动"
      fi
    fi
  fi
  sleep 1
done
