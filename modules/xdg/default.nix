{ pkgs, ... }:
{
  xdg = {
    autostart.enable = true;
    menus.enable = true;
    mime.enable = true;
    icons.enable = true;
    portal = {
      enable = true;
      configPackages = with pkgs; [
        # xdg-desktop-portal-wlr
        # xdg-desktop-portal-gtk
        # xdg-desktop-portal-hyprland
        xdg-desktop-portal-gnome
        # xdg-desktop-portal
        # kdePackages.xdg-desktop-portal-kde
        # libsForQt5.xdg-desktop-portal-kde
        gnome-keyring
      ];
      extraPortals = with pkgs; [
        # xdg-desktop-portal-wlr
        # xdg-desktop-portal-gtk
        # xdg-desktop-portal-hyprland
        xdg-desktop-portal-gnome
        # xdg-desktop-portal
        # kdePackages.xdg-desktop-portal-kde
        gnome-keyring
      ];
      xdgOpenUsePortal = true;
      wlr.enable = true;
    };

  };
  security.rtkit.enable = true;

  security.polkit.enable = true;
  services.gnome.gnome-keyring.enable = true;
  systemd.user.services.niri-flake-polkit = {
    description = "PolicyKit Authentication Agent provided by niri-flake";
    wantedBy = [ "niri.service" ];
    after = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.libsForQt5.polkit-kde-agent}/libexec/polkit-kde-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };
}
