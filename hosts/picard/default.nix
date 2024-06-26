{
  fleetModules,
  lib,
  config,
  pkgs,
  ...
}: {
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
      "waydroid"
      "virt-manager"
      "ssh-initrd"
      "hercules-ci"
      "printing"
      "pam"
      "wireguard-client"
      "restic"
      "binfmt"
      "greetd"
      "syncthing"
      "hass-poweroff"
      "forgejo-runners"
      "teamviewer"
      # "macos-ventura"
      # "sunshine"
      "mount-rock5b"
      "adb"
    ]
    ++ [
      ./disko.nix
    ];

  ccr = {
    enable = true;
    autologin = false;
    modules = [
      "git"
      "git-workspace"
      "helix"
      "shell"
      "element"
      "emacs"
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
      "dolphin"
      "tor-browser"
      "kicad"
      "monero"
    ];
    extraGroups = [];
    backupPaths = [];
  };

  boot.kernelParams = ["ip=dhcp"];
  boot.initrd.kernelModules = ["amdgpu"];
  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "ahci"
    "usbhid"
    "r8169"
  ];
  boot.kernelModules = [
    "kvm-amd"
    "ddci"
    "ddcci-backlight"
  ];
  boot.extraModulePackages = [config.boot.kernelPackages.ddcci-driver];

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 20;
  };

  boot.kernelPackages = pkgs.linuxKernel.packages.linux_6_7;

  networking.hostId = "5b02e763";

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "schedutil";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  hardware.enableRedistributableFirmware = lib.mkDefault true;

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };

  # TODO move away from here (how can the interface name be retrieved programmatically?)
  networking.interfaces.enp11s0.wakeOnLan = {
    enable = true;
    policy = ["magic"];
  };
}
