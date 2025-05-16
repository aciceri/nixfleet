{
  config,
  pkgs,
  lib,
  ...
}:
let
  rev = "f24579d13ee035af96d4a68b765af2aa4b1018b6";
  garmin-grafana-flake = builtins.getFlake "github:NixOS/nixpkgs/${rev}";
  inherit (garmin-grafana-flake.legacyPackages.${pkgs.system}) garmin-grafana;
in
{
  users.users.garmin-grafana = {
    isSystemUser = true;
    group = "garmin-grafana";
    extraGroups = [ "garmin-grafana" ];
    home = "/var/lib/garmin-grafana";
  };

  users.groups.garmin-grafana = { };

  systemd.services.garmin-grafana = {
    description = "garmin-grafana";
    wantedBy = [ "multi-user.target" ];
    environment = {
      INFLUXDB_HOST = "localhost";
      INFLUXDB_PORT = "8086"; # it's hardcoded in the influxdb NixOS module
      INFLUXDB_USERNAME = "garmin-grafana";
      INFLUXDB_PASSWORD = "password"; # FIXME terrible but the databse is not exposed at least
      INFLUXDB_DATABASE = "garmin-stats";
      GARMINCONNECT_IS_CN = "False";
      USER_TIMEZONE = "Europe/Rome";
      KEEP_FIT_FILES = "True";
      ALWAYS_PROCESS_FIT_FILES = "True";
      # MANUAL_START_DATE = "2024-06-01";
      # MANUAL_END_DATE = "2025-12-31";
    };
    serviceConfig = {
      ExecStart = lib.getExe garmin-grafana;
      Group = "garmin-grafana";
      User = "garmin-grafana";
      WorkingDirectory = "/var/lib/garmin-grafana";
    };
  };

  # garmin-grafana uses influxdb V1, probably it's the only software I'll ever use using the V1
  # so I"m keeping its declaration inside this module
  services.influxdb.enable = true;

  environment.persistence."/persist".directories = [
    "/var/lib/garmin-grafana"
    config.services.influxdb.dataDir
  ];
}
