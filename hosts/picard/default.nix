{
  fleetModules,
  lib,
  config,
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
      "waydroid"
      "virt-manager"
      "ssh-initrd"
      "printing"
      "pam"
      "wireguard-client"
      "binfmt"
      "greetd"
      "syncthing"
      "hass-poweroff"
      "forgejo-runners"
      "teamviewer"
      # "macos-ventura"
      "sunshine"
      "mount-sisko"
      "adb"
      "prometheus-exporters"
      "promtail"
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
      # "zulip"
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
      "ib-tws"
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
    "ahci"
    "usbhid"
    "r8169"
  ];
  boot.kernelModules = [
    "kvm-amd"
    "ddcci"
    "ddcci-backlight"
    "i2c-dev" # needed?
  ];

  boot.extraModulePackages = [
    config.boot.kernelPackages.ddcci-driver
  ];

  systemd.services.ddcci = {
    script = ''
      echo 'ddcci 0x37' > /sys/bus/i2c/devices/i2c-2/new_device
    '';
    wantedBy = [ "graphical.target" ];
    restartIfChanged = false;
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
  };

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot = {
    enable = lib.mkForce false; # needed by lanzaboote
  };
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/etc/secureboot";
    configurationLimit = 20;
  };

  boot.kernelPackages = pkgs.linuxPackages;

  networking.hostId = "5b02e763";

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "schedutil";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  hardware.enableRedistributableFirmware = lib.mkDefault true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };

  hardware.rtl-sdr.enable = true;

  # TODO move away from here (how can the interface name be retrieved programmatically?)
  networking.interfaces.enp11s0.wakeOnLan = {
    enable = true;
    policy = [ "magic" ];
  };

  hardware.hackrf.enable = true;
}
