{ config, ... }:
let
  cfg = config.services.prometheus;
in
{
  services.prometheus = {
    enable = true;
    pushgateway = {
      enable = true;
      web = {
        listen-address = "sisko.fleet:9094";
      };
    };
    checkConfig = false; # Otherwise it will fail because it cannot access bearer_token_file
    webExternalUrl = "https://status.aciceri.dev";
    globalConfig.scrape_interval = "10s";
    scrapeConfigs = [
      {
        job_name = "hass";
        metrics_path = "/api/prometheus";
        bearer_token_file = config.age.secrets.home-assistant-token.path;
        static_configs = [
          {
            targets = [
              "sisko.fleet:${builtins.toString config.services.home-assistant.config.http.server_port}"
            ];
          }
        ];
      }
      {
        job_name = "pushgateway";
        static_configs = [
          {
            targets = [ cfg.pushgateway.web.listen-address ];
          }
        ];
      }
      {
        job_name = "node";
        static_configs = [
          {
            targets = builtins.map (host: "${host}.fleet:9100") [
              "sisko"
              "picard"
              "kirk"
            ];
          }
        ];
      }
      {
        job_name = "wireguard";
        static_configs = [
          {
            targets = builtins.map (host: "${host}.fleet:9586") [
              "picard"
              "kirk"
            ];
          }
        ];
      }
      {
        job_name = "zfs";
        static_configs = [
          {
            targets = builtins.map (host: "${host}.fleet:9134") [
              "picard"
              "kirk"
            ];
          }
        ];
      }
      {
        job_name = "restic";
        static_configs = [
          {
            targets = builtins.map (host: "${host}.fleet:9753") [ "sisko" ];
          }
        ];
      }
      {
        job_name = "postgres";
        static_configs = [
          {
            targets = builtins.map (host: "${host}.fleet:9187") [ "sisko" ];
          }
        ];
      }
      {
        job_name = "nginx";
        static_configs = [
          {
            targets = builtins.map (host: "${host}.fleet:9117") [ "sisko" ];
          }
        ];
      }
      {
        job_name = "smartctl";
        static_configs = [
          {
            targets = builtins.map (host: "${host}.fleet:9633") [
              "sisko"
              "kirk"
              "picard"
            ];
          }
        ];
      }
    ];
  };
  environment.persistence."/persist".directories = [
    "/var/lib/${cfg.stateDir}"
  ];
}
