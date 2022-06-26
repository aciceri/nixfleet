{ config, lib, pkgs, profiles, ... }:

{
  imports = with profiles; [ mount-nas sshd dbus avahi printing xdg docker adb syncthing qmk-udev ];

  system.stateVersion = "22.05";

  services.gnome.gnome-keyring.enable = true; # test for VSCode, it works. TODO: move away from here

  boot = {
    initrd.availableKernelModules = [ "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
    initrd.kernelModules = [ ];
    kernelModules = [ "kvm-intel" "snd-aloop" "v4l2loopback" ];
    extraModulePackages = with config.boot.kernelPackages; [
      v4l2loopback
      pkgs.v4l2loopback-dc
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
      fsType = "ext4";
    };

  fileSystems."/home" =
    {
      device = "/dev/disk/by-label/home";
      fsType = "ext4";
    };

  swapDevices =
    [{ device = "/dev/disk/by-label/swap"; }];

  nix = {
    gc = {
      automatic = lib.mkForce false; # Temporarily disabled, TODO: re-enable
      options = "--delete-older-than 3d";
    };
    # package = pkgs.nixFromMaster;
    package = pkgs.nix;
    extraOptions = lib.mkForce ''
      experimental-features = ca-derivations nix-command flakes

      keep-outputs = true
      keep-derivations = true
    '';
  };

  systemd.services.nix-daemon.serviceConfig = {
    LimitNOFILE = lib.mkForce "Infinity"; # 131072; # should help with fds errors due to experimental feature `ca-derivations`
  };

  networking.firewall = {
    enable = true;
    allowPing = true;
  };

}
