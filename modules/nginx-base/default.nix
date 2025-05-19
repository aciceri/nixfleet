{ config, ... }:
{
  security.acme = {
    acceptTerms = true;
    defaults.email = "andrea.ciceri@autistici.org";
    certs = {
      "aciceri.dev" = {
        reloadServices = [ "nginx.service" ];
        domain = "aciceri.dev";
        extraDomainNames = [
          "*.sisko.zt.aciceri.dev"
          "*.sisko.wg.aciceri.dev"
        ];
        dnsProvider = "cloudflare";
        dnsPropagationCheck = true;
        group = config.services.nginx.group;
        environmentFile = config.age.secrets.cloudflare-api-tokens.path;
      };
    };
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  services.nginx = {
    enable = true;
    statusPage = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
  };

  environment.persistence."/persist".directories = [
    "/var/lib/acme"
  ];
}
