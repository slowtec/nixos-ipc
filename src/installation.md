# IPC Linux Installation

Start the IPC and login as root.

## Internet Access

Make sure the IPC is connected to the internet.

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

#### Your Notebook as a Router

Sometimes your notebook has access via WiFi to the internet and you
want to provide this access to the IPC over ethernet.

This is how the setup looks like:

    [IPC-Server]
       |
       +->(enp1s0  = 192.168.0.200/24)-+
                                       |
                                       |
       +--(enp0s25 = 192.168.0.133/24)-+
       |
       v
    [Notebook]->(wlp0s25 = DHCP)-->[Internet]

On the server we do:

    route add default gw 192.168.0.133 enp1s0
    echo "nameserver 8.8.8.8" >> /etc/resolv.conf

On the notebook we do:

    su
    ip addr add 192.168.0.133/24 dev enp0s25
    nix-env -i iptables
    echo 1 > /proc/sys/net/ipv4/ip_forward
    iptables -t nat -A POSTROUTING -o wlp4s0 -j MASQUERADE

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

Finally trigger the installation process:

    nixos-install
    reboot
