{ pkgs, ... }:
{
  services.dbus.packages = with pkgs; [ gnome3.dconf ];
  programs.dconf.enable = true;
}
