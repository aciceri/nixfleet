{ config, lib, pkgs, profiles, ... }:

{
  imports = with profiles; [ mount-nas sshd dbus avahi printing xdg docker adb syncthing qmk-udev ];

  boot = {
    initrd.availableKernelModules = [ "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
    initrd.kernelModules = [ ];
    kernelModules = [ "kvm-intel" "v4l2loopback" ];
    extraModulePackages = with config.boot.kernelPackages; [
      v4l2loopback
    ];

    extraModprobeConfig = ''
      options v42loopback exclusive_caps=1 max_buffers=2
    '';

    binfmt.emulatedSystems = [ "aarch64-linux" ];

    loader.grub = pkgs.lib.mkForce {
      enable = true;
      version = 2;
      device = "/dev/sda";
    };
  };

  sound.enable = true;

  hardware = {
    opengl.enable = true;
    pulseaudio = {
      enable = true;
      package = pkgs.pulseaudioFull;
    };
  };

  fileSystems."/" =
    {
      device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
    };

  swapDevices =
    [{ device = "/dev/disk/by-label/swap"; }];

  nix = {
    package = pkgs.nixUnstable;
    gc = {
      automatic = true;
      options = "--delete-older-than 3d";
    };
  };

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}
