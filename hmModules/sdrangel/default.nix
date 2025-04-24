{ pkgs, ... }:
{
  home.packages = [
    (builtins.getFlake "github:NixOS/nixpkgs/063dece00c5a77e4a0ea24e5e5a5bd75232806f8")
    .legacyPackages.${pkgs.system}.sdrangel
    pkgs.kdePackages.qtlocation
  ];
}
