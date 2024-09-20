{ pkgs, ... }:
{
  home.packages = with pkgs; [
    winetricks
    wineWowPackages.waylandFull
  ];
}
