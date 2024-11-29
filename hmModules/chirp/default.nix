{ pkgs, ... }:
let
in
# nixpkgs = builtins.getFlake "github:NixOS/nixpkgs/932fc16b263f26803d3960e4400bc13dde84a972";
# chirp = nixpkgs.legacyPackages.${pkgs.system}.chirp;
{
  home.packages = [ pkgs.chirp ];
}
