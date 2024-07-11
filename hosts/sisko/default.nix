{
  fleetModules,
  pkgs,
  fleetFlake,
  config,
  ...
}: {
  imports =
    fleetModules [
      "common"
      "ssh"
      "ccr"
      "wireguard-server"
      "mediatomb"
      "transmission"
      "hercules-ci"
      "home-assistant"
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
      # "matrix"
      "forgejo"
      # "jellyfin"
      # "immich"
    ]
    ++ [
      ./disko.nix
    ];

  # FIXME why is this needed?
  nixpkgs.config.permittedInsecurePackages = ["openssl-1.1.1w"];
  # boot.kernelPackages = pkgs.linuxKernel.packages.linux_6_8;
  # boot.kernelPackages = pkgs.linuxPackagesFor pkgs.linux_testing;
  boot.kernelPackages = let
    pkgs = fleetFlake.inputs.nixpkgsUnstableForSisko.legacyPackages.aarch64-linux;
  in
    pkgs.linuxPackagesFor pkgs.linux_testing;
  # boot.kernelPackages = pkgs.linuxPackagesFor (pkgs.linux_6_9.override {
  #   argsOverride = {
  #     src = pkgs.fetchFromGitLab {
  #       domain = "gitlab.collabora.com";
  #       owner = "hardware-enablement/rockchip-3588";
  #       repo = "linux";
  #       rev = "23bb9c65a88c114bbe945b7ef5366bb02d3d9b80";
  #       sha256 = "sha256-6TygOl5r7/N2jlcPznWlvJfVVeXKSR8yMoGuTDbIdTA=";
  #     };
  #     version = "6.9";
  #     modDirVersion = "6.9.0";
  #   };
  # });

  system.stateVersion = "24.05";

  powerManagement.cpuFreqGovernor = "schedutil";

  ccr.enable = true;

  # services.rock5b-fan-control.enable = true;

  nixpkgs.hostPlatform = "aarch64-linux";

  swapDevices = [];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = false;
  };

  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "ahci"
  ];

  boot.kernelParams = [
    "console=tty1"
    "console=ttyS0,1500000"
  ];

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
