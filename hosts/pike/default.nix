{
  fleetModules,
  lib,
  config,
  ...
}:
{
  imports = fleetModules [
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
    "waydroid"
    "virt-manager"
    "ssh-initrd"
    "printing"
    "pam"
    "wireguard-client"
    "binfmt"
    "greetd"
    # "syncthing"
    "teamviewer"
    "sunshine"
    "mount-sisko"
    "adb"
    "prometheus-exporters"
    # "promtail"
    "zerotier"
  ];

  ccr = {
    enable = true;
    autologin = false;
    modules = [
      "git"
      "git-workspace"
      "helix"
      "shell"
      "zellij"
      # "element"
      "zmkbatx"
      "tremotesf"
      "firefox"
      "gpg"
      "mpv"
      "password-store"
      "slack"
      "hyprland"
      "niri"
      "udiskie"
      "xdg"
      # "spotify"
      "wine"
      "cura"
      "chrome"
      "email"
      "digikam"
      "dolphin"
      "tor-browser"
      "kicad"
      "monero"
      "teams"
      "obs-studio"
      "calibre"
      "reinstall-magisk-on-lineage"
      "vscode-server"
      "zk"
      "catppuccin"
      "freecad"
      "zathura"
      "imv"
      "libreoffice"
      "emacs"
      "vial"
      "chirp"
      "sdrangel"
      "discord"
      "zoom"
      "pantalaimon"
    ];
    extraGroups = [ "plugdev" ];
    backupPaths = [ ];
  };

  boot.kernelParams = [ "ip=dhcp" ];
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "usbhid"
    "thunderbolt"
    "vmd"
    "usb_storage"
    "sd_mod"
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  fileSystems."/" = {
    device = "zpool/root";
    fsType = "zfs";
    options = [ "zfsutil" ];
  };

  fileSystems."/nix" = {
    device = "zpool/nix";
    fsType = "zfs";
    options = [ "zfsutil" ];
  };

  fileSystems."/var" = {
    device = "zpool/var";
    fsType = "zfs";
    options = [ "zfsutil" ];
  };

  fileSystems."/home" = {
    device = "zpool/home";
    fsType = "zfs";
    options = [ "zfsutil" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/4AA5-7242";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };

  fileSystems."/mnt/shared" = {
    device = "/dev/nvme0n1p2";
    fsType = "ntfs";
    options = [ "nofail" ];
  };

  services.zfs.autoScrub.enable = true;

  networking.hostId = "30fc8ed7";

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "schedutil";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  hardware.enableRedistributableFirmware = lib.mkDefault true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };
}
