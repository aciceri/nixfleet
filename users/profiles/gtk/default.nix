{ pkgs, ... }:
{
  gtk = {
    enable = true;
    font.name = "DejaVu Sans";
    theme = {
      name = "WhiteSur-dark-alt-blue";
      package = pkgs.whitesur-gtk-theme;
    };
    iconTheme = {
      name = "Adwaita";
      package = pkgs.gnome.adwaita-icon-theme;
    };
  };
  # home.file.".icons/default" = {
  #   recursive = true;
  #   source = let
  #     drv = pkgs.stdenv.mkDerivation {
  #       name = "apple-cursor";
  #       src = pkgs.fetchurl {
  #         url = "https://github.com/ful1e5/apple_cursor/releases/download/v1.2.0/macOSBigSur.tar.gz";
  #         sha256 = "sha256-8QNd8EEf11MIBVUbgZy6U1ZnDIWj92EGQmKLR8Edqfw=";
  #       };
  #       installPhase = ''
  #         mkdir -p $out
  #         mv * $out/
  #       '';
  #     };
  #   in
  #     "${drv}/";
  # };
}
