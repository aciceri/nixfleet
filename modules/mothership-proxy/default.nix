{ ... }:
{
  imports = [ ../nginx-base ];
  services.nginx.virtualHosts = {
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
    "sevenofnix.aciceri.dev" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://thinkpad.fleet:8010";
        proxyWebsockets = true;
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
