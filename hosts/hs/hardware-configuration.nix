{ lib, ... }:
{
  boot = {
    initrd.availableKernelModules = [
      "ohci_pci"
      "ehci_pci"
      "ahci"
      "usb_storage"
      "usbhid"
      "sd_mod"
    ];
    loader.grub = lib.mkForce {
      enable = true;
      version = 2;
      device = "/dev/disk/by-id/ata-OCZ-VERTEX_TMHAK8OARSURAIF6N1A5";
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
    };
    "/mnt/archivio" = {
      device = "/dev/disk/by-label/archivio";
      fsType = "ext4";
    };
    "/mnt/film" = {
      device = "/dev/disk/by-label/film";
      fsType = "ext4";
    };
  };

  swapDevices = [ { device = "/dev/disk/by-label/swap"; } ];
}
