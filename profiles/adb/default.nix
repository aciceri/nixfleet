{ pkgs, ... }:
{
  programs.adb.enable = !pkgs.stdenv.hostPlatform.isAarch64;

  services.udev.packages = [
    pkgs.android-udev-rules
  ];
}
