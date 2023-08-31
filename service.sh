#!/system/bin/sh

MODDIR=${0%/*}

sleep 15

if [ -e "$MODDIR/singBoxWiFi" ]; then
  $MODDIR/singBoxWiFi || sh "$MODDIR/神秘WIFI自动启停.sh" > $MODDIR/log 2>&1
else
  sh "$MODDIR/神秘WIFI自动启停.sh" > $MODDIR/log 2>&1
fi
