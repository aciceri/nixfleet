{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.adb.enable = true;
  users.users.ccr.extraGroups = ["adbusers"];
}