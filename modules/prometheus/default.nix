{config, ...}: let
  cfg = config.services.prometheus;
in {
  services.prometheus = {
    enable = true;
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
            targets = ["sisko.fleet:${builtins.toString config.services.home-assistant.config.http.server_port}"];
          }
        ];
      }
      {
        job_name = "node";
        static_configs = [
          {
            targets = builtins.map (host: "${host}.fleet:9100") ["sisko" "picard"];
          }
        ];
      }
    ];
  };
  environment.persistence."/persist".directories = [
    "/var/lib/${cfg.stateDir}"
  ];
}
