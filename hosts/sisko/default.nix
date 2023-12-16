{
  fleetModules,
  pkgs,
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
      # "adguard-home"
      # "mount-hetzner-box"
      "cloudflare-dyndns"
      "rock5b-proxy"
      "invidious"
      "searx"
      "rock5b-samba"
      "paperless"
    ]
    ++ [
      ./disko.nix
    ];

  ccr.enable = true;

  services.rock5b-fan-control.enable = true;

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
