#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar
# If all your bars have ipc enabled, you can also use
# polybar-msg cmd quit

# Launch barMonitor or barInternal

x=$(xrandr)

if echo "$x" | grep "HDMI-A-0 disconnected"; then
    pkill polybar && sleep 1
    echo "---" | tee -a /tmp/polybar1.log /tmp/polybar2.log
    polybar barInternal 2>&1 | tee -a /tmp/polybar1.log & disown
    echo "Bars launched..."
else
    pkill polybar && sleep 1
    echo "---" | tee -a /tmp/polybar1.log /tmp/polybar2.log
    polybar barMonitor 2>&1 | tee -a /tmp/polybar1.log & disown
    echo "Bars launched..."
fi