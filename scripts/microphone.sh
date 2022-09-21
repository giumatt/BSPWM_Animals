#!/bin/bash

tonor=$(lsusb | grep "TONOR")

if [ -n "$tonor" ]; then
	noisetorch -i -s "alsa_input.usb-FuZhou_Kingwayinfo_CO._LTD_TONOR_TC30_Audio_Device_20200707-00.pro-input-0"
fi
