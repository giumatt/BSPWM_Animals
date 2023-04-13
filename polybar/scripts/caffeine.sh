#!/bin/bash

case "$1" in
	--toggle)
		if pidof "caffeine-ng" > /dev/null
		then
			notify-send -u normal "Caffeine disabled."
			caffeine kill
		else
			notify-send -u normal "Caffeine enabled."
			caffeine start
		fi
		;;
	*)
		echo ""
		;;
esac
