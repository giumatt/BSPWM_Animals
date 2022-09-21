#!/bin/bash

# Startup applications

setxkbmap us -variant intl
$HOME/.screenlayout/ciao.sh &
xsetroot -cursor_name left_ptr &

# User applications

#picom &
#$HOME/.config/polybar/launch.sh &
#dunst -conf $HOME/.config/dunst/dunstrc &
#nitrogen --restore &
## To launch one time opensnitch
#pgrep -x opensnitch-ui > /dev/null || opensnitch-ui
#numlockx &
