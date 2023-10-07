# Creality K1 - USB Camera from front USB Port
(Creality K1 - Webcam utilizando a USB frontal)

## Follow this steps to Install
(Siga estes passos para instalação)

SSH access to your printer and run:
(Acesse sua impressora via SSH e execute este comando:)
```sh
(cd ~/ && git clone https://github.com/trevos3d/K1-USB-Cam.git && cd K1-USB-Cam && chmod +x *.sh && ./install.sh)
```
Caso a webcam não apareça automaticamente no Fluidd, reinicie a impressora.

## Uninstall (It will clean all USB Camera files)
(Para desinstalar - Isso vai remover todos os arquivos relativos a esta instalação)

```sh
(cd ~/K1-USB-Cam && git pull && ./uninstall.sh)
```

## Update (when available)
(Para atualizar, caso haja uma atualização disponivel)

```sh
(cd ~/K1-USB-Cam && git pull && ./install.sh)
```

## To get camera access
(Acessando a camera)

Access the url for the cameras:
(Acesse a url abaixo alterando o endereço pro IP da sua impressora.)

- USB camera stream: [http://your-printer-IP:8080/?action=stream](http://your-printer-IP:8080/?action=stream)
- USB camera snapshot: [http://your-printer-IP:8080/?action=snapshot](http://your-printer-IP:8080/?action=snapshot)

Please remember to change *your-printer-IP* on url above.
(Não esqueça de alterar o *your-printer-IP* para o endereço IP da sua camera)