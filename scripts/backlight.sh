#!/usr/bin/env bash

sudo chgrp video /sys/class/backlight/amdgpu_bl0/brightness
sudo chmod g+w /sys/class/backlight/amdgpu_bl0/brightness
