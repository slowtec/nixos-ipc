# IPC Linux Installation

Start the IPC and login as root.
If you are using a German keyboard you can use

```
loadkeys de
```
to load the corresponding keyboard layout.

## Internet Access

Make sure the IPC is connected to the internet
(you might use [your notebook as a router](maintenance.html#your-notebook-as-a-router)).

### WiFi

To use WiFi you can use `wpa_supplicant`:

    touch /etc/wpa_supplicant.conf

Add the following into it:

    network={
        ssid="ssid_name"
        psk="password"
    }

Then you can activate the WiFi interface:

    wpa_supplicant -B -iwlan0 -c/etc/wpa_supplicant.conf -Dwext
    dhclient wlan0

## Creating Partitions

We need to create a root and a swap partition
(to list all existing devices use `fdisk -l`):

    fdisk /dev/mmcblk0

- root partition: `n`, `p`, `1`, `+20G`
- swap partition: `n`, `p`, `2`
- set boot flag: `a`
- write to disk: `w`

Afterwards you can format the partitions.

    mkfs.ext4 -j -L nixos /dev/mmcblk0p1
    mkswap -L swap /dev/mmcblk0p2

## Perform the NixOS installation

You might first adjust the channel and update it:

    nix-channel --update

Then mount the root partition (labeled as `nixos`):

    mount LABEL=nixos /mnt

Generate the NixOS configuration for the IPC:

    nixos-generate-config --root /mnt

Adjust the `/mnt/etc/nixos/configuration.nix` file for your needs.

An example configuration looks like this:

```nix
{{#include ../configuration.nix}}
```

You can also download this configuration:

```
curl -o /mnt/etc/nixos/configuration.nix https://raw.githubusercontent.com/slowtec/nixos-ipc/master/configuration.nix
```

Finally trigger the installation process:

    nixos-install
    reboot
