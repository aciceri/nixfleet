{
  fleetModules,
  pkgs,
  lib,
  ...
}: {
  imports =
    fleetModules [
      "common"
      "ssh"
      "ccr"
      "wireguard-server"
      # "minidlna"
      "mediatomb"
      "transmission"
      "hercules-ci"
      # "bubbleupnp"
      # "nextcloud"
      "home-assistant"
      # "immich"
      "adguard-home"
      "cloudflare-dyndns"
      "rock5b-proxy"
      "invidious"
      "searx"
      "rock5b-samba"
      "paperless"
      "restic"
      "syncthing"
      "minio"
    ]
    ++ [
      ./disko.nix
    ];

  # FIXME why is this needed?
  nixpkgs.config.permittedInsecurePackages = ["openssl-1.1.1w"];

  # boot.kernelPackages = pkgs.linuxPackagesFor pkgs.linux_testing;
  boot.kernelPackages = pkgs.linuxPackagesFor (pkgs.linux_testing.override {
    argsOverride = {
      src = pkgs.fetchFromGitLab {
        domain = "gitlab.collabora.com";
        owner = "hardware-enablement/rockchip-3588";
        repo = "linux";
        rev = "b07290444a7fb5cf56a5200d2bad7f927e77e8b8";
        sha256 = "sha256-ruD9+vRwFQOXf5PWB+QxtA8DWfOcIydD0nSekoQTqWw=";
      };
      version = "6.7";
      modDirVersion = "6.7.0";
    };
  });

  powerManagement.cpuFreqGovernor = "schedutil";

  ccr.enable = true;

  # services.rock5b-fan-control.enable = true;

  nixpkgs.hostPlatform = "aarch64-linux";

  swapDevices = [];

  boot.loader = {
    grub.enable = false;
    generic-extlinux-compatible.enable = true;
  };

  # fileSystems."/mnt/film" = {
  #   device = "//ccr.ydns.eu/film";
  #   fsType = "cifs";
  #   options = let
  #     credentials = pkgs.writeText "credentials" ''
  #       username=guest
  #       password=
  #     '';
  #   in ["credentials=${credentials},x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s"];
  # };
  # fileSystems."/mnt/archivio" = {
  #   device = "//ccr.ydns.eu/archivio";
  #   fsType = "cifs";
  #   options = let
  #     credentials = pkgs.writeText "credentials" ''
  #       username=guest
  #       password=
  #     '';
  #   in ["credentials=${credentials},x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s"];
  # };

  fileSystems."/mnt/hd" = {
    device = "/dev/disk/by-id/ata-WDC_WD10EADS-22M2B0_WD-WCAV52709550-part1";
    fsType = "ext4";
    options = ["nofail"];
  };

  environment.systemPackages = with pkgs; [
    cifs-utils
  ];
}
