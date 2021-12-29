{ pkgs, ... }:
{
  programs.adb.enable = !pkgs.stdenv.hostPlatform.isAarch64;
}
