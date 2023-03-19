{
  config,
  lib,
  pkgs,
  ...
}: {
  disko.devices = import ./disko.nix {};

  boot = {
    initrd.availableKernelModules = ["usbhid"];
    extraModulePackages = with config.boot.kernelPackages; [
      v4l2loopback
    ];
    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };
  };

  hardware = {
    opengl.enable = true;
    pulseaudio = {
      enable = true;
      package = pkgs.pulseaudioFull;
    };
    bluetooth = {
      enable = true;
      settings = {
        General = {
          MultiProfile = "multiple";
          ControllerMode = "dual";
          AutoConnect = true;
        };
        Policy = {
          AutoEnable = true;
        };
      };
    };
  };

  services.blueman.enable = true;

  networking = {
    useDHCP = false;
    interfaces.wlan0.useDHCP = true;
    networkmanager.enable = true;
  };

  time.timeZone = "Europe/Rome";

  powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";

  services.logind.extraConfig = ''
    HandlePowerKey=ignore
  '';
}
