# Preparation

## Prerequisites

You'll need:

- an IPC
- USB-Hub (to connect both a keyboard and the USB stick)
- USB stick
- Monitor + HDMI cable
- Internet access
- Linux computer (e.g. installed with Ubuntu 18.04 LTS)

## NixOS USB Stick

First download a stable [NixOS ISO image](https://nixos.org/nixos/download.html):

```
sudo apt-get install wget curl
curl https://raw.githubusercontent.com/slowtec/nixos-ipc/master/download-nixos.sh -sSf | sh
```

Afterwards there should be a `nixos.iso` file within your download folder.
Install this image on a USB stick:

1. Format your stick with the FAT32 file system.  
   This can be done e.g. with `fdisk` or if you're uncomfortable with the command line
   you can use a graphical tool like [GParted](https://gparted.org/).
2. Set the boot flag
3. Set the partition label to `NIXOS_ISO` (e.g. `dosfslabel /dev/sdb1 "NIXOS_ISO"`)
4. Install `unetbootin` ([unetbootin.github.io](https://unetbootin.github.io/))
5. Start `unetbootin` and use the downloaded image

Now you can boot the IPC from the stick.
Make sure the IPC is connected with to the internet.

## BIOS

After starting the IPC, make sure the following BIOS settings
were made:

- disable Hibernation (`Advanced` > `ACPI Settings` > `Enable Hibernation` > `Disabled`)
- disable Suspend (`Advanced` > `ACPI Sleep State` > `Suspend Disabled`)
- enable automatic boot after power failure (`Chipset` > `Restore AC Power Loss` > `Power On`)
- set boot priority (`Boot` > `Boot Option Priorities` > `Boot Option #1` > `USB DISK 2.0`)
