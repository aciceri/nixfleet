{
  fleetModules,
  pkgs,
  config,
  ...
}:
{
  imports =
    fleetModules [
      "common"
      "ssh"
      "ccr"
      "wireguard-server"
      "mediatomb"
      "transmission"
      # "hercules-ci"
      "home-assistant"
      "adguard-home"
      "cloudflare-dyndns"
      "rock5b-proxy"
      "invidious"
      "searx"
      "rock5b-samba"
      # "paperless"
      # "restic"
      # "syncthing"
      # "minio"
      # # "matrix"
      "forgejo"
      # # "jellyfin"
      # "immich"
      "prometheus"
      "grafana"
      "prometheus-exporters"
      "loki"
      "promtail"
      "garmin-collector"
      "restic"
      # "immich"
      "atuin"
    ]
    ++ [
      ./disko.nix
    ];

  # boot.kernelPackages = pkgs.linuxKernel.packages.linux_6_8;
  boot.kernelPackages = pkgs.linuxPackagesFor pkgs.linux_6_10;
  # boot.kernelPackages = let
  #   pkgs = fleetFlake.inputs.nixpkgsForSisko.legacyPackages.aarch64-linux;
  # in
  #   pkgs.linuxPackagesFor pkgs.linux_testing;
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

  nixpkgs.hostPlatform = "aarch64-linux";

  swapDevices = [ ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = false;
  };

  hardware.deviceTree.enable = true;
  hardware.deviceTree.name = "rockchip/rk3588-rock-5b.dtb";
  boot.loader.systemd-boot.installDeviceTree = true;

  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "ahci"
    "usb_storage"
  ];

  boot.kernelParams = [
    "console=tty1"
    "console=ttyS0,1500000"
  ];

  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/etc/NetworkManager/system-connections"
      "/var/db/dhcpcd/"
      "/var/lib/NetworkManager/"
      "/var/lib/nixos"
      "/var/lib/systemd"
      "/var/lib/systemd/coredump"
      "/var/log"
      "/var/lib/containers"
      "/var/lib/postgresql"
      "/home/${config.ccr.username}/.ssh"
    ];
    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
    ];
  };

  age.identityPaths = [
    "/persist/etc/ssh/ssh_host_ed25519_key"
    "/persist/etc/ssh/ssh_host_rsa_key"
  ];

  fileSystems."/persist".neededForBoot = true;
  boot.tmp.cleanOnBoot = true;

  fileSystems."/mnt/hd" = {
    device = "/dev/disk/by-id/ata-WDC_WD5000AAKX-08U6AA0_WD-WCC2E5TR40FU-part1";
    fsType = "ext4";
    options = [ "nofail" ];
  };

  environment.systemPackages = with pkgs; [
    cifs-utils
  ];
}
