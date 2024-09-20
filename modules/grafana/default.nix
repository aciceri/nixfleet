{ config, ... }:
let
  cfg = config.services.grafana;
in
{
  services.grafana = {
    enable = true;
    settings = {
      server = {
        domain = "status.aciceri.dev";
        http_addr = "127.0.0.1";
        http_port = 2342;
        root_url = "https://${config.services.grafana.settings.server.domain}:443/";
      };
      security = {
        admin_user = "andrea";
        admin_password = "$__file{${config.age.secrets.grafana-password.path}}";
      };
      smtp = {
        enabled = true;
        host = "smtp.autistici.org:587";
        user = "andrea.ciceri@autistici.org";
        from_address = "andrea.ciceri@autistici.org";
        password = "$__file{${config.age.secrets.autistici-password.path}}";
      };
    };
  };
  environment.persistence."/persist".directories = [
    cfg.dataDir
  ];

  services.nginx.virtualHosts = {
    "status.aciceri.dev" = {
      enableACME = true;
      forceSSL = true;
      locations."/".proxyPass = "http://127.0.0.1:${builtins.toString cfg.settings.server.http_port}";
    };
  };
}
