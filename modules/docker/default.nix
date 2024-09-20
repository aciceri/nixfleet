{
  pkgs,
  ...
}:
{
  virtualisation.podman.enable = true;
  # virtualisation.docker.enable = true;
  environment.systemPackages = with pkgs; [
    docker-compose
    podman-compose
  ];
  ccr.extraGroups = [
    "docker"
    "podman"
  ];
}
