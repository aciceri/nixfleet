{
  fleetModules,
  lib,
  config,
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
      "restic"
      "greetd"
      "syncthing"
      "mount-rock5b"
      "adb"
      "binfmt"
      "prometheus-exporters"
    ]
    ++ [
      ./disko.nix
    ];

  ccr = {
    enable = true;
    autologin = true;
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
      "udiskie"
      "xdg"
      "spotify"
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
    ];
    extraGroups = [ ];
    backupPaths = [ ];
  };

  boot.initrd.kernelModules = [ "i915" ];
  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "usb_storage"
    "sd_mod"
  ];
  boot.kernelModules = [
    "kvm-intel"
  ];

  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 20;
  };

  networking.hostId = "3a7683ae";

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "schedutil";
  hardware.enableRedistributableFirmware = lib.mkDefault true;

  hardware.opengl = {
    enable = true;
    driSupport32Bit = true;
  };
}
