{ pkgs, ... }:
{
  home.packages = with pkgs; [
    openscad
  ] ++ (if !stdenv.hostPlatform.isAarch64 then [
    blender
    freecad
  ]
  else [ ]);
}
