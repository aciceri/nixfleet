{ ... }:
{
  networking.firewall.interfaces."wg0" = {
    allowedTCPPorts = [
      35901
    ];
  };
  imports = [ ../nginx-base ];
  services.nginx.virtualHosts = {
    "roam.aciceri.dev" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://localhost:35901";
        proxyWebsockets = true;
      };
    };
  };

  # TODO use oauth2 proxy
}
