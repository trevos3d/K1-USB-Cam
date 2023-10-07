# Creality K1 - USB Camera from front USB Port


## Follow this steps to Install

SSH access to your printer and run:
```sh
(cd ~/ && git clone https://github.com/trevos3d/K1-USB-Cam.git && cd K1-USB-Cam && chmod +x *.sh && ./install.sh)
```

## Uninstall (It will clean all USB Camera files)

```sh
(cd ~/K1-USB-Cam && git pull && ./uninstall.sh)
```

## Update (when available)

```sh
(cd ~/K1-USB-Cam && git pull && ./install.sh)
```

## To get camera access

Access the url for the cameras:
- USB camera stream: [http://your-printer-IP:8080/?action=stream](http://your-printer-IP:8080/?action=stream)
- USB camera snapshot: [http://your-printer-IP:8080/?action=snapshot](http://your-printer-IP:8080/?action=snapshot)

Please remember to change *your-printer-IP* on url above.
