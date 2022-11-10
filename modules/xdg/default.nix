{pkgs, ...}: {
  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
      ];
    };
  };

  services.pipewire.enable = true;

  environment.sessionVariables = {
    GTK_USE_PORTAL = "1";
  };
}
