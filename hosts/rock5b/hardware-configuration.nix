{lib, ...}: {
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_ROOTFS";
      fsType = "ext4";
    };
  };

  swapDevices = [];

  boot.loader = {
    grub.enable = false;
    generic-extlinux-compatible.enable = true;
  };
}
