{ config, ... }:
{
  services.alloy = {
    enable = true;
  };
  environment.etc."alloy/config.alloy".text = ''
    local.file_match "local_files" {
      path_targets = [{
        __path__ = "/var/log/*.log",
      }]
      sync_period = "5s"
    }

    loki.source.journal "systemd" {
      max_age    = "24h"
      forward_to = [loki.write.default.receiver]
    }

    loki.source.journal "kernel" {
      max_age = "24h"
      forward_to = [loki.write.default.receiver]
    }

    loki.relabel "nixfleet_journal" {
      forward_to = []
      rule {
      	source_labels = ["__journal__systemd_unit"]
      	target_label = "systemd_unit"
      }
      rule {
      	source_labels = ["__journal_syslog_identifier"]
      	target_label = "syslog_identifier"
      }
    }

    loki.source.journal "nixfleet_journal" {
      forward_to = [loki.write.default.receiver]
      relabel_rules = loki.relabel.nixfleet_journal.rules
      format_as_json = true
    }

    loki.write "default" {
      endpoint {
        url = "http://sisko.wg.aciceri.dev:${
          builtins.toString config.services.loki.configuration.server.http_listen_port or 3100
        }/loki/api/v1/push"
      }
      external_labels = {
        host = "${config.networking.hostName}",
      }
    }
  '';
}
