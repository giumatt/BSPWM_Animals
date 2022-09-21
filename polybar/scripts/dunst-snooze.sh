#!/bin/sh

case "$1" in
    --toggle)
        notify-send -u normal "Notifications disabled."
        sleep 1
        dunstctl close-all
        dunstctl set-paused toggle

        if [ "$(dunstctl is-paused)" = "false" ]; then
            notify-send -u normal "Notifications enabled."
        fi
        ;;
    *)
        echo ""
        ;;
esac