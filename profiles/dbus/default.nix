{ pkgs, ... }:
{
  services.dbus.packages = with pkgs; [ dconf ];
  programs.dconf.enable = true;
}
