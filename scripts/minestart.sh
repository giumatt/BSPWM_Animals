#!/bin/bash

PID=$(sudo pidof java)

if [[ $1 = "start" ]]; then
	sudo renice $2 -p $PID
elif [[ $1 = "stop" ]]; then
	sudo renice 0 -p $PID
fi
