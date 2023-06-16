{
  config,
  pkgs,
  ...
}: {
  boot.supportedFilesystems = ["zfs"];
  networking.hostId = "adf0b5e7";
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.loader.efi.canTouchEfiVariables = false;
  boot.loader.generationsDir.copyKernels = true;
  boot.loader.grub.efiInstallAsRemovable = true;
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.copyKernels = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.zfsSupport = true;
  boot.loader.grub.extraPrepareConfig = ''
    mkdir -p /boot/efis
    for i in  /boot/efis/*; do mount $i ; done

    mkdir -p /boot/efi
    mount /boot/efi
  '';
  boot.loader.grub.extraInstallCommands = ''
    ESP_MIRROR=$(mktemp -d)
    cp -r /boot/efi/EFI $ESP_MIRROR
    for i in /boot/efis/*; do
     cp -r $ESP_MIRROR/EFI $i
    done
    rm -rf $ESP_MIRROR
  '';
  boot.loader.grub.devices = [
    "/dev/disk/by-id/nvme-INTEL_SSDPEKKF010T8L_PHHP938405741P0D"
  ];
  users.users.root.initialHashedPassword = "$6$EqXfyFLxUZfpmJ8F$UH3pLcHwgLpOZwiSDhdq/iR/p.uyZZYlk6G4Q0S8BtYr3Qt2xKU56Fwv3Mgco.J0i3cx1Nm8XMfvythSuv8gh/";

  # TODO: remove this when it will be no more necessary
  # boot.zfs.enableUnstable = true;
  # nixpkgs.overlays = [
  #   (self: super: {
  #     linuxPackages_zen = super.linuxPackages_zen.extend (lpSelf: lpSuper: {
  #       zfsUnstable = lpSuper.zfsUnstable.overrideAttrs (_: {
  #         meta.broken = false;
  #       });
  #     });
  #   })
  # ];
}
