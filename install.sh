#!/bin/sh

cp script/startup_usb_camera.sh /usr/data/startup_usb_camera.sh
chmod +x /usr/data/startup_usb_camera.sh

cp service/S99usb_camera /etc/init.d/S99usb_camera
chmod +x /etc/init.d/S99usb_camera

echo "Successfully Installed K1-USB-Cam"

echo "Starting Webcam Service"
chmod +x /etc/init.d/S99usb_camera
/etc/init.d/S99usb_camera start
