#!/bin/sh

sleep 2m

killall mjpg_streamer 2>/dev/null || true
for i in $(seq 4 8); do fuser -k /dev/video$i 2>/dev/null; done

mjpg_streamer -b -i "/usr/lib/mjpg-streamer/input_uvc.so -d /dev/video4" -o "/usr/lib/mjpg-streamer/output_http.so -p 8080"
