{
  config,
  lib,
  pkgs,
  ...
}: {
  virtualisation.docker.enable = true;
  users.users.ccr.extraGroups = ["docker"];
  environment.systemPackages = with pkgs; [
    docker-compose
  ];
}
