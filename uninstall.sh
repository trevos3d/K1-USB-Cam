#!/bin/sh


echo "Removing all K1-USB-CAM files"

rm /usr/data/startup_usb_camera.sh /etc/init.d/S99usb_camera

echo "Uninstalled, please reboot your printer."
