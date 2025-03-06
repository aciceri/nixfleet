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
        kdePackages.xdg-desktop-portal-kde
        libsForQt5.xdg-desktop-portal-kde
        gnome-keyring
      ];
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
        xdg-desktop-portal-hyprland
        xdg-desktop-portal-gnome
        xdg-desktop-portal
        kdePackages.xdg-desktop-portal-kde
        gnome-keyring
      ];
      xdgOpenUsePortal = true;
      wlr.enable = true;
    };
  };
}
