#!/bin/sh

sleep 2m

killall mjpg_streamer 2>/dev/null || true
for i in $(seq 4 8); do fuser -k /dev/video$i 2>/dev/null; done

CAM1=$(v4l2-ctl --list-devices | grep -A 3 usb | grep -A 2 "CREALITY CAM" | tail -n 1 | awk '{$1=$1; print}')
CAM2=$(v4l2-ctl --list-devices | grep -v "CREALITY" | grep "usb" -A 1 | grep -E "/dev/video[0-9]+" | tail -n 1 | awk '{$1=$1; print}')
export CAM1
export CAM2


mjpg_streamer -b -i "/usr/lib/mjpg-streamer/input_uvc.so -d $CAM1" -i "/usr/lib/mjpg-streamer/input_uvc.so -d $CAM2" -o "/usr/lib/mjpg-streamer/output_http.so -p 8080"
