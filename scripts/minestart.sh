#!/bin/bash

# A usaeful script capable to renice Minecraft process (Java) in order to increase the priority.
# I use it during startup of big modded servers.

PID=$(sudo pidof java)

if [[ $1 = "start" ]]; then
	sudo renice $2 -p $PID
elif [[ $1 = "stop" ]]; then
	sudo renice 0 -p $PID
fi
