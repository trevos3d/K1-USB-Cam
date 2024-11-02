#!/bin/sh

kill -9 $(pidof mjpg_streamer)
for i in $(seq 4 8); do fuser /dev/video$i; done

mjpg_streamer -b -i "/usr/lib/mjpg-streamer/input_uvc.so -d /dev/video4" -o "/usr/lib/mjpg-streamer/output_http.so -p 8080"