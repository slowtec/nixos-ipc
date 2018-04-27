{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.kernelParams = ["nomodeset"];

  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "/dev/mmcblk0"; # This depends on your hardware
  };

  networking = {

    hostName = "nixos-ipc"; # Define your hostname.

    wireless.enable = false;

    interfaces = {
      # LAN A
      enp1s0 = {
        ipAddress = "192.168.0.200";
        prefixLength = 24;
      };
      # LAN B
      enp2s0 = {
        ipAddress = "192.168.0.100";
        prefixLength = 24;
      };
      # WLAN
      wlp3s0 = {
        ipAddress = "192.168.1.1";
        prefixLength = 24;
      };
    };
  };

  i18n = {
    consoleKeyMap = "de";
    defaultLocale = "de_DE.UTF-8";
  };

  time.timeZone = "Europe/Berlin";

  environment.systemPackages = with pkgs; [
    htop
    vim
    dfc
    which
    wget
    tree
  ];

  services.openssh = {
    enable = true;
    permitRootLogin = "no"; # Be careful if you switch it to "yes"!
  };

  services.haveged.enable = true;

  services.dhcpd4 = {
    enable = true;
    interfaces = ["wlp3s0"];
    extraConfig = ''
      subnet 192.168.1.0 netmask 255.255.255.0 {
          range 192.168.1.10 192.168.1.99;
      }'';
  };

  services.hostapd = {
    interface = "wlp3s0";
    enable = true;
    ssid = "ipc";
    wpaPassphrase = "nixos-ipc"; # Change it to something secure
    channel = 5;
  };

  # FIX: start hostapd after wlp3s0 is up
  systemd.services.hostapd.after = [
    "sys-subsystem-net-devices-wlp3s0.device"
    "bind.service"
    "dhcpd.service"
  ];

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];

  networking.firewall.enable = true;

  services.printing.enable = false;

  # Define the users for your system
  # users.extraUsers.user = {
  #   isNormalUser = true;
  # };

  system.stateVersion = "18.03";
}
