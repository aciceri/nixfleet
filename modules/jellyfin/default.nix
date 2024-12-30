{ config, ... }:
{
  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };

  users.users.jellyfin.extraGroups = [ "transmission" ];

  environment.persistence."/persist".directories = [
    config.services.jellyfin.dataDir
  ];

  services.nginx.virtualHosts = {
    "jelly.aciceri.dev" = {
      enableACME = true;
      forceSSL = true;
      locations."/".proxyPass = "http://127.0.0.1:8096";
    };
  };
}
