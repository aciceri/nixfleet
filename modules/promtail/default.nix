{
  pkgs,
  lib,
  config,
  ...
}: let
  conf = {
    server = {
      http_listen_port = 28183;
      grpc_listen_port = 0;
    };
    clients = [
      {
        url = "http://sisko.fleet:${builtins.toString config.services.loki.configuration.server.http_listen_port or 3100}/loki/api/v1/push";
      }
    ];
    positions = {
      filename = "/tmp/positions.yaml";
    };
    scrape_configs = [
      {
        job_name = "journal";
        journal = {
          max_age = "12h";
          labels = {
            job = "systemd-journal";
            host = config.networking.hostName;
          };
        };
        relabel_configs = [
          {
            source_labels = ["__journal__systemd_unit"];
            target_label = "unit";
          }
        ];
      }
    ];
  };
  configFile = pkgs.writeTextFile {
    name = "promtail.yaml";
    text = lib.generators.toYAML {} conf;
  };
in {
  systemd.services.promtail = {
    description = "Promtail service for Loki";
    wantedBy = ["multi-user.target"];

    serviceConfig = {
      ExecStart = ''
        ${pkgs.grafana-loki}/bin/promtail --config.file ${configFile}
      '';
    };
  };
}
