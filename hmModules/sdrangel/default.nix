{ pkgs, ... }:
{
  home.packages = [
    pkgs.sdrangel
    pkgs.kdePackages.qtlocation
  ];
}
