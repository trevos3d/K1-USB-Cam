#!/bin/sh


echo "Removing all K1-USB-CAM files"

# Stop the service and kill any running streamer before removing files
/etc/init.d/S99usb_camera stop 2>/dev/null || true
killall mjpg_streamer 2>/dev/null || true

rm -f /usr/data/startup_usb_camera.sh /etc/init.d/S99usb_camera /var/run/usb_camera.pid
rm -rf /usr/data/K1-USB-Cam

echo "Uninstalled, please reboot your printer."
