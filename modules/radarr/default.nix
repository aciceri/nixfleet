{
  services.radarr = {
    enable = true;
  };

  services.nginx.virtualHosts."radarr.sisko.wg.aciceri.dev" = {
    forceSSL = true;
    useACMEHost = "aciceri.dev";
    locations."/" = {
      proxyPass = "http://localhost:7878"; # FIXME hardcoded port
    };
    serverAliases = [ "radarr.sisko.zt.aciceri.dev" ];
  };
}
