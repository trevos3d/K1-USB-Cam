#!/bin/bash

Single_USB_Camera()
{
    echo -e "\n$msg \nInstalling Single USB camera...\n"
    cp -f script/single_cam.sh /usr/data/startup_usb_camera.sh
    chmod +x /usr/data/startup_usb_camera.sh

    cp service/S99usb_camera /etc/init.d/S99usb_camera
    chmod +x /etc/init.d/S99usb_camera

    echo "Successfully Installed USB Camera"

    echo "Starting Webcam Service"
    chmod +x /etc/init.d/S99usb_camera
    /etc/init.d/S99usb_camera start

    echo -e "\n \e[1;31m Please consider reboot your printer to make sure that all process will work property.\e[0m \n" 
}

Dual_USB_Camera()
{
    echo -e "\n$msg \nInstalling Dual USB camera...\n"
    cp -f script/dual_cam.sh /usr/data/startup_usb_camera.sh
    chmod +x /usr/data/startup_usb_camera.sh

    cp service/S99usb_camera /etc/init.d/S99usb_camera
    chmod +x /etc/init.d/S99usb_camera

    echo "Successfully Installed K1 + USB Camera"

    echo "Starting Webcam Service"
    chmod +x /etc/init.d/S99usb_camera
    /etc/init.d/S99usb_camera start

    echo -e "\n \e[1;31m Please consider reboot your printer to make sure that all process will work property.\e[0m \n" 
}


echo "" 
PS="How can I help you today? "

select msg in "Install Single USB Camera" "Install K1 + USB Cam" Quit
do
    case $msg in
        "Install Single USB Camera")
            Single_USB_Camera ;;
        "Install K1 + USB Cam")
           Dual_USB_Camera ;;
        "Quit")
           echo "We're done here."
           break;;
        *)
           echo "Ooops";;
    esac
done




#cp script/startup_usb_camera.sh /usr/data/startup_usb_camera.sh
#chmod +x /usr/data/startup_usb_camera.sh

#cp service/S99usb_camera /etc/init.d/S99usb_camera
#chmod +x /etc/init.d/S99usb_camera

#echo "Successfully Installed K1-USB-Cam"

#echo "Starting Webcam Service"
#chmod +x /etc/init.d/S99usb_camera
#/etc/init.d/S99usb_camera start
