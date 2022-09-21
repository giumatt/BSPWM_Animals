#!/bin/sh

if bluetoothctl show | grep -q "Powered: no"; then
    bluetoothctl power on >> /dev/null
    notify-send -u normal "Bluetooth enabled."
    sleep 1
elif bluetoothctl show | grep -q "Powered: yes"; then
    #devices_paired=$(bluetoothctl paired-devices | grep Device | cut -d ' ' -f 2)
    #echo "$devices_paired" | while read -r line; do
    #    bluetoothctl disconnect "$line" >> /dev/null
    #done
    bluetoothctl power off >> /dev/null
    notify-send -u normal "Bluetooth disabled."
    sleep 1
fi