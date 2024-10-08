#
# Minimum config used to enable Plasma Mobile.
#
{
  lib,
  ...
}:
{
  mobile.beautification = {
    silentBoot = lib.mkDefault false;
    splash = lib.mkDefault false;
  };

  services.xserver = {
    enable = true;

    #   # desktopManager.plasma5.mobile.enable = true;

    #   displayManager.autoLogin = {
    #     enable = true;
    #   };

    #   displayManager.session = [{
    #     manage = "desktop";
    #     name = "hyprland";
    #     start = ''
    #       ${pkgs.hyprland}/bin/Hyprland &
    #       waitPID=$!
    #     '';
    #     }];

    #   displayManager.defaultSession = "hyprland";

    #   displayManager.lightdm = {
    #     enable = true;
    #     # Workaround for autologin only working at first launch.
    #     # A logout or session crashing will show the login screen otherwise.
    #     extraSeatDefaults = ''
    #       session-cleanup-script=${pkgs.procps}/bin/pkill -P1 -fx ${pkgs.lightdm}/sbin/lightdm
    #     '';
    #   };

    libinput.enable = true;
  };

  hardware.bluetooth.enable = true;
  hardware.pulseaudio.enable = lib.mkDefault true; # mkDefault to help out users wanting pipewire
  networking.networkmanager.enable = true;
  networking.wireless.enable = false;
  powerManagement.enable = true;
}
