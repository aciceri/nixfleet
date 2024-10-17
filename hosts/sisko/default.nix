{
  fleetModules,
  pkgs,
  ...
}:
{
  imports =
    fleetModules [
      "common"
      "ssh"
      "wireguard-server"
      "mediatomb"
      "transmission"
      # "hercules-ci"
      "home-assistant"
      "adguard-home"
      "cloudflare-dyndns"
      "sisko-proxy"
      "invidious"
      "searx"
      "sisko-nfs"
      "forgejo"
      "prometheus"
      "grafana"
      "prometheus-exporters"
      "loki"
      "promtail"
      "garmin-collector"
      "restic"
      "atuin"
      "immich"
      "paperless"
      "syncthing"
    ]
    ++ [
      ./disko.nix
    ];

  boot.kernelPackages = pkgs.linuxPackagesFor pkgs.linux_6_11;

  system.stateVersion = "24.05";

  powerManagement.cpuFreqGovernor = "schedutil";

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

  environment.systemPackages = with pkgs; [
    cifs-utils
  ];
}
