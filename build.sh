#!/bin/sh

zip -r -o -X sing-box-wifi_$(cat module.prop | grep 'version=' | awk -F '=' '{print $2}').zip ./ -x '.git/*' -x 'build.sh' -x '.github/*' -x 'sing-box-wifi.json'
