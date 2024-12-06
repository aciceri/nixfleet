{
  modulesPath,
  fleetModules,
  pkgs,
  lib,
  vpn,
  config,
  ...
}:
{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix") ]
    ++ fleetModules [
      "common"
      "ssh"
      "nix"
      "networkmanager"
      "dbus"
      "udisks2"
      "xdg"
      "printing"
      "mara"
      "xfce"
      "battery"
      "printing"
      "wireguard-client"
    ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ehci_pci"
    "ahci"
    "usb_storage"
    "sd_mod"
    "sr_mod"
    "rtsx_pci_sdmmc"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];
  boot.loader.grub.device = "/dev/sda";

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/1522f8d9-5251-408d-9b6e-ed6da7da916a";
    fsType = "btrfs";
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/e111fbc7-8e5d-4fcb-95c9-249f53ab0adc"; }
  ];

  mara = {
    enable = true;
    modules = [
      "shell"
      "mpv"
      "firefox"
      "git"
      "chrome"
      "udiskie"
      "helix"
      "remmina"
    ];
  };

  # nevertheless this is a laptop the battery is completely gone, so it works only attached to electrictiy
  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";

  networking.firewall.allowedTCPPorts = [ 1234 ];

  hardware.rtl-sdr.enable = true;

  systemd.services.rtl-tcp = {
    description = "rtl_sdr over TCP";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = ''
        ${lib.getExe' pkgs.rtl-sdr "rtl_tcp"} -a ${vpn.${config.networking.hostName}}
      '';
    };
  };

  systemd.services.sdrangelsrv = {
    description = "sdrangelsrv";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = ''
        ${lib.getExe' pkgs.sdrangel "sdrangelsrv"} --remote-tcp-hwtype RTLSDR --remote-tcp-port 1234 --remote-tcp-address ${
          vpn.${config.networking.hostName}
        } --remote-tcp
      '';
    };
  };
}
