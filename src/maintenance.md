# Maintenance

## Your Notebook as a Router

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

## Remote access via Mobile Router

In case the maintenace of a system is done remotely via a mobile router
unusual problems might occur.

### Coping data via scp

Coping a file as usual

```
scp localfile user@remote-host:/path/to/destination/
```
can lead problems.
For instance the progress stops every time at e.g. exactly 2112 KBytes,
no matter how large the file is.
In some cases it can be a solution to decrease the MTU
([Maximum Transmission Unit](https://en.wikipedia.org/wiki/Maximum_transmission_unit)).
The default value of 1500 Bytes can be changed with:

```
ifconfig tun0 mtu 1300
```

An other option is to enable SSH compression with the `-C` flag:
```
scp -C localfile user@remote-host:/path/to/destination/
```

Moreover large files can be compressed before the transmission:

```
tar czvf localfile.tar.gz localfile
```
On the target IPC the file can be unpacked afterwards with:
```
tar xzf localfile.tar.gz
```

## Tunneling Services via SSH

Let's say you like to access a WebApplication that is running locally on the IPC
which can only be accessed from `localhost`
but you want run it in your own browser.
In that case you can tunnel the corresponding port through SSH.
The syntax is as follows:

```
ssh -L LOCAL_PORT:HOST_NAME:REMOTE_PORT USER@REMOTE_HOST -N
```
The key here is `-L` which says we’re doing local port forwarding.
In case the WebApplication is served on `127.0.0.1:3000`
with a WebSocket server running on `127.0.0.1:8081` on the IPC that can
be accesst via `192.168.0.200` you'd do the following:

```
ssh -L 8000:127.0.0.1:3000 root@192.168.0.200 -N
```
This is like *"forward my local port 8000 to port 3000 at 127.0.0.1 on the server"* and
```
ssh -L 8081:127.0.0.1:8081 root@192.168.0.200 -N
```
which is like *"forward my local port 8081 to port 8081 at 127.0.0.1 on the server"*

Now open your browser and go to `http://localhost:8000`.

## Build NixOS from local repository

```
git clone https://github.com/NixOS/nixpkgs.git
cd nixpkgs/
```
You might checkout a specific version, e.g.
```
git checkout 2f6440e
```
or modify any files you like.

Finally you can trigger the rebuild:
```
nixos-rebuild -I nixpkgs=. switch
```

## GPU info

If need to know some information about the installed CPU
you can use `lshw` (`nix-env -iA nixos.lshw`):

```
lshw -C display
```

To analyse an intel GPU you can do the following:

```
nix-env -iA nixos.intel-gpu-tools
intel_gpu_top
```
