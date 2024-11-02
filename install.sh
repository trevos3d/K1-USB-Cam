#!/bin/sh

Single_USB_Camera()
{
    echo ""
    echo "$msg Installing Single USB camera..."
    cp -f script/single_cam.sh /usr/data/startup_usb_camera.sh
    chmod +x /usr/data/startup_usb_camera.sh

    cp service/S99usb_camera /etc/init.d/S99usb_camera
    chmod +x /etc/init.d/S99usb_camera

    echo "Successfully Installed USB Camera"

    echo "Starting Webcam Service"
    chmod +x /etc/init.d/S99usb_camera
    /etc/init.d/S99usb_camera start

    echo  "Please consider reboot your printer to make sure that all process will work property." 
}

Dual_USB_Camera()
{
    echo ""
    echo "$msg Installing Dual USB camera..."
    cp -f script/dual_cam.sh /usr/data/startup_usb_camera.sh
    chmod +x /usr/data/startup_usb_camera.sh

    cp service/S99usb_camera /etc/init.d/S99usb_camera
    chmod +x /etc/init.d/S99usb_camera

    echo "Successfully Installed K1 + USB Camera"

    echo "Starting Webcam Service"
    chmod +x /etc/init.d/S99usb_camera
    /etc/init.d/S99usb_camera start

    echo "Please consider reboot your printer to make sure that all process will work property." 
}


echo "" 
PS=

while : 
do

    

    echo "1) Install Single USB Camera"

    echo "2) Install K1 + USB Cam"

    echo "3) exit"

    echo "How can I help you today? "

    read msg;

    case $msg in
        1) echo "Install Single USB Camera"
            echo "----------------------------"
            Single_USB_Camera
            exit ;;
        2) echo "Install K1 + USB Cam"
            echo "----------------------------"
            Dual_USB_Camera 
            exit ;;
        3) echo "Quit"
            echo "----------------------------"
            echo "We're done here."
            exit ;;
        *)
            echo "Ooops, invalid option."
    esac
    sleep .5
done
