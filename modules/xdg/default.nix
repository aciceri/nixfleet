{ pkgs, ... }:
{
  xdg = {
    portal = {
      enable = true;
      configPackages = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
        xdg-desktop-portal-hyprland
        xdg-desktop-portal-gnome
        xdg-desktop-portal
        xdg-desktop-portal-kde
      ];
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
        xdg-desktop-portal-hyprland
        xdg-desktop-portal-gnome
        xdg-desktop-portal
        xdg-desktop-portal-kde
      ];
      xdgOpenUsePortal = true;
      wlr.enable = true;
    };
  };
}
