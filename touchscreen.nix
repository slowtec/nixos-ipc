{ config, lib, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    xinput_calibrator
    evtest
    usbutils
  ];

  # CHANGE ME:
  # run 'xinput_calibrator' and add the
  # generated config below
  services.xserver.config = ''
    Section "InputClass"
       Identifier     "calibration"
        MatchProduct  "eGalax Inc. USB TouchController"
       Option         "Calibration"   "167 4024 3950 189"
       Option         "SwapAxes"      "1"
    EndSection
    '';
}
