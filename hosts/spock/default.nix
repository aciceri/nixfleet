{
  lib,
  modulesPath,
  ...
}:
{
  imports = [
    "${modulesPath}/installer/sd-card/sd-image-aarch64.nix"
  ];

  sdImage.compressImage = false;

  nixpkgs = {
    # hostPlatform = lib.mkDefault "armv6-linux";
    # config = {
    #   allowUnfree = true;
    # };
    # overlays = [
    #   # Workaround: https://github.com/NixOS/nixpkgs/issues/154163
    #   # modprobe: FATAL: Module sun4i-drm not found in directory
    #   (final: super: {
    #     makeModulesClosure = x:
    #       super.makeModulesClosure (x // {allowMissing = true;});
    #   })
    # ];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = [ "noatime" ];
    };
  };

  networking = {
    networkmanager.enable = false;
  };

  # Set your time zone.
  time.timeZone = "Europe/Rome";

  # Allow the user to log in as root without a password.
  users.users.root.initialHashedPassword = "";

  hardware.enableRedistributableFirmware = true;
  system.stateVersion = "24.11";
}
