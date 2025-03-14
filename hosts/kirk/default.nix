{
  fleetModules,
  lib,
  pkgs,
  ...
}:
{
  imports =
    fleetModules [
      "common"
      "ssh"
      "ccr"
      "nix"
      "networkmanager"
      "bluetooth"
      "dbus"
      "docker"
      "fonts"
      "qmk-udev"
      "mosh"
      "udisks2"
      "xdg"
      "pipewire"
      "nix-development"
      "virt-manager"
      "ssh-initrd"
      "printing"
      "pam"
      "wireguard-client"
      "greetd"
      "syncthing"
      "mount-sisko"
      "adb"
      "binfmt"
      "prometheus-exporters"
      "promtail"
      "syncthing"
      "zerotier"
    ]
    ++ [ ./disko.nix ];

  ccr = {
    enable = true;
    autologin = false;
    modules = [
      "git"
      "git-workspace"
      "helix"
      "shell"
      "zellij"
      "element"
      "firefox"
      "gpg"
      "mpv"
      "password-store"
      "slack"
      "hyprland"
      "niri"
      "udiskie"
      "xdg"
      "lutris"
      "wine"
      "cura"
      "chrome"
      "email"
      "digikam"
      "discord"
      "remmina"
      "zulip"
      "calibre"
      "zathura"
      "imv"
      "catppuccin"
      "libreoffice"
      "emacs"
      "chirp"
      "sdrangel"
      "zmkbatx"
    ];
    extraGroups = [ "plugdev" ];
    backupPaths = [ ];
  };

  boot.initrd.kernelModules = [ "i915" ];
  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "usb_storage"
    "sd_mod"
  ];
  boot.kernelModules = [ "kvm-intel" ];

  boot.kernelPackages = pkgs.linuxPackages;

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 20;
  };

  networking.hostId = "3a7683ae";

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "schedutil";
  hardware.enableRedistributableFirmware = lib.mkDefault true;
  hardware.rtl-sdr.enable = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };
}
