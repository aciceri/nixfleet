{
  lib,
  fleetModules,
  ...
}: {
  imports = fleetModules [
    "nix"
  ];

  system.stateVersion = lib.mkForce "22.11";
  time.timeZone = lib.mkDefault "Europe/Rome";
  networking.useDHCP = lib.mkDefault true;
  users.mutableUsers = false;
  users.users.root.password = "password";
  i18n.defaultLocale = "en_US.UTF-8";
}
