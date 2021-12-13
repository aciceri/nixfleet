{ pkgs, ... }:
{
  home.packages = with pkgs; [
  ] ++ (if !stdenv.hostPlatform.isAarch64 then [
    blender
  ]
  else [ ]);
}
