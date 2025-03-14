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
      "sisko-share"
      "forgejo"
      "prometheus"
      "grafana"
      "prometheus-exporters"
      "loki"
      "promtail"
      "restic"
      "atuin"
      "immich"
      "paperless"
      "syncthing"
      "atticd"
      "jellyfin"
      "firefly"
      "matrix"
      "radarr"
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
    "earlycon"
    "consoleblank=0"
    "console=tty1"
    "console=ttyS2,1500000"
  ];

  systemd.services."serial-getty@ttyS2" = {
    enable = true;
    wantedBy = [ "getty.target" ];
    serviceConfig.restart = "always";
  };

  users.users.root.hashedPassword = "$y$j9T$mLSUS2hvJdN3s8f9Y3uLE0$sYQtJdn4DuSAZnDkhSsV0WIxNdpuqlH7ODNy1RfuRp4";

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

  powerManagement.scsiLinkPolicy = "med_power_with_dipm";
}
