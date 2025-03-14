{ config, ... }:
{
  services.adguardhome = {
    enable = true;
    port = 3000;
    mutableSettings = true;
    settings = {
      openFirewall = true;
    };
  };
  networking.firewall.allowedTCPPorts = [
    3000
    53
  ];
  networking.firewall.allowedUDPPorts = [ 53 ];
  environment.persistence."/persist".directories = [
    "/var/lib/AdGuardHome"
  ];

  services.nginx.virtualHosts."adguard.sisko.wg.aciceri.dev" = {
    forceSSL = true;
    useACMEHost = "aciceri.dev";
    locations."/" = {
      proxyPass = "http://localhost:${builtins.toString config.services.adguardhome.port}";
    };
    serverAliases = [ "adguard.sisko.zt.aciceri.dev" ];
  };
}
