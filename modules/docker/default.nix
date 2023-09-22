{
  config,
  lib,
  pkgs,
  ...
}: {
  virtualisation.docker.enable = true;
  virtualisation.podman.enable = true;
  users.users.ccr.extraGroups = ["docker"];
  environment.systemPackages = with pkgs; [
    docker-compose
    podman-compose
  ];
}
