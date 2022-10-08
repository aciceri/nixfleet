{
  config,
  lib,
  pkgs,
  ...
}: {
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

  fileSystems = {
    "/" = {
      device = "/dev/nvme0n1p1";
      fsType = "btrfs";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/C406-2AFC";
      fsType = "vfat";
    };
  };

  swapDevices = [{device = "/dev/disk/by-uuid/e236d328-496e-4cf8-ba54-857789ca258f";}];

  powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";

  services.logind.extraConfig = ''
    HandlePowerKey=ignore
  '';
}
