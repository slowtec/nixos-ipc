# Preparation

## Prerequisites

You'll need:

- an IPC
- USB-Hub (to connect both a keyboard and the USB stick)
- USB stick
- Monitor + HDMI cable
- Internet
- Linux computer

## BIOS

After starting the IPC, make sure the following BIOS settings
were made:

- disable Hibernation
- disable Suspend
- enable automatic boot after power failure

## NixOS USB Stick

First download a stable [NixOS ISO image](https://nixos.org/nixos/download.html).

Afterwards there should be a `nixos.iso` file within your download folder.
Install this image on a USB stick:

1. Format your stick with the FAT32
2. Set the boot flag
3. Set the partition label to `NIXOS_ISO`
4. Install `unetbootin`
5. Start `unetbootin` and use the downloaded image

Now you can boot the IPC from the stick.
Make sure the IPC is connected with to the internet.
