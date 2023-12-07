{lib, ...}: {
  networking.networkmanager.enable = true;
  ccr.extraGroups = ["networkmanager"];
  networking.useDHCP = lib.mkDefault true;
}
