{
  pkgs,
  lib,
  fleetFlake,
  config,
  ...
}:
{
  users.users.garmin-collector = {
    isSystemUser = true;
    group = "garmin-collector";
    extraGroups = [ "garmin-collector" ];
    home = "/var/lib/garmin-collector";
  };

  users.groups.garmin-collector = { };

  systemd.services.garmin-collector = {
    description = "Garmin collector pushing to Prometheus Pushgateway";
    wantedBy = [ "multi-user.target" ];
    environment = {
      PUSHGATEWAY_ADDRESS = config.services.prometheus.pushgateway.web.listen-address;
    };
    serviceConfig = {
      Group = "garmin-collector";
      User = "garmin-collector";
      WorkingDirectory = "/var/lib/garmin-collector";
      ExecStart = ''
        ${lib.getExe fleetFlake.packages.${pkgs.system}.garmin-collector}
      '';
      EnvironmentFile = config.age.secrets.garmin-collector-environment.path;
    };
  };

  systemd.timers."garmin-collector" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "5m";
      OnUnitActiveSec = "4h";
      Unit = "garmin-collector.service";
    };
  };

  environment.persistence."/persist".directories = [
    "/var/lib/garmin-collector"
  ];
}
