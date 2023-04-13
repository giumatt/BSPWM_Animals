#!/bin/bash

fg=c0caf5
wrong=db4b4b
highlight=565f89
date=7aa2f7
verify=7aa2f7

lock_Internal() {
    i3lock -n --force-clock -i ~/Pictures/Wallpapers/Pink-Floyd-Animals-Expanded.jpg \
    -e --indicator --radius=20 --ring-width=40 --inside-color=$fg \
    --ring-color=$fg --insidever-color=$verify --ringver-color=$verify \
    --insidewrong-color=$wrong --ringwrong-color=$wrong --line-uses-inside \
    --keyhl-color=$verify --separator-color=$verify --bshl-color=$verify \
    --time-str="%H:%M" --time-size=100 --date-str="%a, %d %b" --date-size=35 \
    --verif-text="Verifying password..." --wrong-text="Wrong password!" --noinput-text="" \
    --greeter-text="Type the password to unlock" --ind-pos="250:425" --time-font="SanFranciscoPro Display:style=Bold" \
    --date-font="SanFranciscoPro Display" --verif-font="SanFranciscoPro Display" --greeter-font="SanFranciscoPro Display" --wrong-font="SanFranciscoPro Display" \
    --verif-size=20 --greeter-size=20 --wrong-size=20 --time-pos="250:300" --date-pos="250:350" \
    --greeter-pos="250:500" --wrong-pos="250:525" --verif-pos="250:525" --date-color=$date \
    --time-color=$date --greeter-color=$fg --wrong-color=$wrong --verif-color=$verify \
    --pointer=default --refresh-rate=60 --pass-media-keys --pass-volume-keys
}

lock_External() {
    i3lock -n --force-clock -i ~/Pictures/Wallpapers/Pink-Floyd-Animals-Expanded.jpg \
    -e --indicator --radius=20 --ring-width=40 --inside-color=$fg \
    --ring-color=$fg --insidever-color=$verify --ringver-color=$verify \
    --insidewrong-color=$wrong --ringwrong-color=$wrong --line-uses-inside \
    --keyhl-color=$verify --separator-color=$verify --bshl-color=$verify \
    --time-str="%H:%M" --time-size=100 --date-str="%a, %d %b" --date-size=45 \
    --verif-text="Verifying password..." --wrong-text="Wrong password!" --noinput-text="" \
    --greeter-text="Type the password to unlock" --ind-pos="250:600" --time-font="SanFranciscoPro Display:style=Bold" \
    --date-font="SanFranciscoPro Display" --verif-font="SanFranciscoPro Display" --greeter-font="SanFranciscoPro Display" --wrong-font="SanFranciscoPro Display" \
    --verif-size=23 --greeter-size=23 --wrong-size=23 --time-pos="250:400" --date-pos="250:500" \
    --greeter-pos="250:700" --wrong-pos="250:725" --verif-pos="250:725" --date-color=$date \
    --time-color=$date --greeter-color=$fg --wrong-color=$wrong --verif-color=$verify \
    --pointer=default --refresh-rate=60 --pass-media-keys --pass-volume-keys
}

x=$(xrandr)

if echo "$x" | grep "HDMI-A-0 disconnected"; then
    lock_Internal
else
    lock_External
fi
