{
  pkgs,
  config,
  ...
}: {
  virtualisation.podman.enable = true;
  users.users.${config.ccr.username}.extraGroups = ["docker"];
  environment.systemPackages = with pkgs; [
    docker-compose
    podman-compose
  ];
  ccr.extraGroups = ["docker"];
}
