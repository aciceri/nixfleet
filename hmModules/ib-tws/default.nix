{ fleetFlake, pkgs, ... }:
{
  home.packages = [ fleetFlake.packages.${pkgs.system}.ib-tws ];
}
