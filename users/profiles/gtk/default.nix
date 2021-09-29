{ pkgs, ... }:
{
  gtk = {
    enable = true;
    font.name = "DejaVu Sans";
    iconTheme = {
      name = "Adwaita";
      package = pkgs.gnome.adwaita-icon-theme;
    };
  };
}
