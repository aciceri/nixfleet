{lib, ...}: {
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_ROOTFS";
      fsType = "ext4";
    };
  };

  nixpkgs.hostPlatform = "aarch64-linux";

  swapDevices = [];

  boot.loader = {
    grub.enable = false;
    generic-extlinux-compatible.enable = true;
  };
}
