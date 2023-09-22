{config, ...}: {
  imports = [../nginx-base];
  services.nginx.virtualHosts = {
    "bubbleupnp.mothership.aciceri.dev" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://rock5b.fleet:58050";
      };
    };
    "home.aciceri.dev" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://rock5b.fleet:8123";
        proxyWebsockets = true;
      };
      extraConfig = ''
        proxy_set_header    Upgrade     $http_upgrade;
        proxy_set_header    Connection  $connection_upgrade;
      '';
    };
    "transmission.mothership.aciceri.dev" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://rock5b.fleet:9091";
      };
    };
    "photos.aciceri.dev" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://localhost:8080";
        proxyWebsockets = true;
      };
    };
  };
}
