{ config, lib, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    chromium
  ];

  services.xserver = {
    enable = true;
    layout = "de";

    monitorSection = ''
      Option "NODPMS"
      '';

    serverLayoutSection = ''
      Option "BlankTime" "0"
      Option "DPMS" "false"
      '';

    windowManager.default = "awesome";
    windowManager.awesome.enable = true;

    displayManager = {
      auto.user = "gui";
      auto.enable =  true;
    };

    desktopManager.default = "chromium";
    desktopManager.session = [{
      name = "chromium";
      start = ''
        xset dpms force on
        xset -dpms &
        xset s noblank &
        xset s off &
        xset b off &
        sleep 1;
        while true; do ${pkgs.chromium}/bin/chromium --kiosk http://127.0.0.1.80/; done
      '';
    }];

  };

  users.users.gui = {
    isNormalUser = true;
  };
}
