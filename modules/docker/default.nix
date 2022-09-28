{
  config,
  lib,
  pkgs,
  ...
}: {
  virtualisation.docker.enable = true;
  users.users.ccr.extraGroups = ["docker"];
}
