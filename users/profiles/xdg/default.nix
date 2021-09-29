{ pkgs, ... }:
{
  home.packages = [ pkgs.xdg-utils ];
  xdg = {
    enable = true;
  };
}
