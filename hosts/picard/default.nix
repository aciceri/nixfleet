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
      "hercules-ci"
      "printing"
      "pam"
      "wireguard-client"
      "binfmt"
      "greetd"
      # "syncthing"
      "hass-poweroff"
      "forgejo-runners"
      "teamviewer"
      # "macos-ventura"
      "sunshine"
      "mount-rock5b"
      "adb"
      "guix"
      "prometheus-exporters"
      "promtail"
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
      "zmkbatx"
      "tremotesf"
      # "emacs"
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
      "zulip"
      "teams"
      "obs-studio"
      "calibre"
      "reinstall-magisk-on-lineage"
      "vscode-server"
      "zk"
    ];
    extraGroups = [ ];
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

  # https://github.com/NixOS/nixpkgs/issues/328909
  boot.extraModulePackages = [
    (config.boot.kernelPackages.ddcci-driver.overrideAttrs (old: {
      patches = [ ];
      src = pkgs.fetchFromGitLab {
        owner = "${old.pname}-linux";
        repo = "${old.pname}-linux";
        rev = "7853cbfc28bc62e87db79f612568b25315397dd0";
        hash = "sha256-QImfvYzMqyrRGyrS6I7ERYmteaTijd8ZRnC6+bA9OyM=";
      };
    }))
  ];

  systemd.services.ddcci = {
    serviceConfig.Type = "oneshot";
    script = ''
      echo 'ddcci 0x37' > /sys/bus/i2c/devices/i2c-2/new_device
    '';
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

  boot.kernelPackages = pkgs.linuxKernel.packages.linux_6_10;

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

  # TODO move away from here (how can the interface name be retrieved programmatically?)
  networking.interfaces.enp11s0.wakeOnLan = {
    enable = true;
    policy = [ "magic" ];
  };
}
