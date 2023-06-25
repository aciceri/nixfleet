{
  imports = [../nginx-base];
  services.nginx.virtualHosts = {
    "bubbleupnp.mothership.aciceri.dev" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://rock5b.fleet:58050";
      };
    };
    "transmission.mothership.aciceri.dev" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://rock5b.fleet:9091";
      };
    };
  };
}
