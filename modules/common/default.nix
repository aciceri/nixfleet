{
  lib,
  fleetModules,
  ...
}: {
  imports = fleetModules [
    "nix"
  ];

  hardware.i2c.enable = true;
  system.stateVersion = lib.mkForce "22.11";
  time.timeZone = lib.mkDefault "Europe/Rome";
  users.mutableUsers = false;
  i18n.defaultLocale = "en_US.UTF-8";
  nixpkgs.config.allowUnfree = true; # Forgive me Mr. Stallman :(
}
