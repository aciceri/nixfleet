{ lib, ... }:
{
  networking.networkmanager.enable = true;
  networking.useDHCP = lib.mkDefault true;
}
