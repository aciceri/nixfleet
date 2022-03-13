{ config, lib, pkgs, unstableKernelForPBP, profiles, ... }:

{
  imports = with profiles; [ mount-nas sshd dbus avahi printing xdg syncthing ];

  boot = {
    initrd.availableKernelModules = [ "usbhid" ];
    kernelPackages = unstableKernelForPBP;
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
  };

  networking = {
    useDHCP = false;
    interfaces.wlan0.useDHCP = true;
    networkmanager.enable = true;
  };

  time.timeZone = "Europe/Rome";
  location.provider = "geoclue2";

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/5aa67d2d-93fd-4e7c-b634-aa8d7b65bbb8";
      fsType = "btrfs";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/C406-2AFC";
      fsType = "vfat";
    };
  };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/e236d328-496e-4cf8-ba54-857789ca258f"; }];


  nix = {
    gc = {
      automatic = true;
      options = "--delete-older-than 3d";
    };
  };

  powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";
}
