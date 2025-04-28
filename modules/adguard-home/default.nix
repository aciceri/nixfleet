{ config, lib, ... }:
{
  services.adguardhome = {
    enable = true;
    mutableSettings = true;
    settings = {
      dhcp = {
        enabled = true;
        interface_name = "enP4p65s0";

        dhcpv4 = {
          gateway_ip = "10.1.1.1";
          range_start = "10.1.1.2";
          range_end = "10.1.1.255";
          subnet_mask = "255.255.255.0";
        };
      };
      dns = {
        upstream_dns = [
          "https://dns10.quad9.net/dns-query"
        ];

        bind_hosts = [
          "127.0.0.1"
          "10.1.1.2"
        ];
      };
    };
  };

  systemd.services.adguardhome.serviceConfig.DynamicUser = lib.mkForce false;

  networking.firewall.allowedUDPPorts = [
    53
    67
  ];
  networking.firewall.allowedTCPPorts = [ 53 ];
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
