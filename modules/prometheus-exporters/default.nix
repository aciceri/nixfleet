{
  config,
  lib,
  pkgs,
  ...
}:
let
  hostname = config.networking.hostName;
  mkFor = hosts: lib.mkIf (builtins.elem hostname hosts);
in
{
  services.prometheus.exporters = {
    node =
      mkFor
        [
          "sisko"
          "picard"
          "kirk"
          "pike"
        ]
        {
          enable = true;
          enabledCollectors = [
            "cpu"
            "conntrack"
            "diskstats"
            "entropy"
            "filefd"
            "filesystem"
            "loadavg"
            "mdadm"
            "meminfo"
            "netdev"
            "netstat"
            "stat"
            "time"
            "vmstat"
            "systemd"
            "logind"
            "interrupts"
            "ksmd"
            "textfile"
            "pressure"
          ];
          extraFlags = [
            "--collector.ethtool"
            "--collector.softirqs"
            "--collector.tcpstat"
            "--collector.wifi"
          ];
        };
    wireguard =
      mkFor
        [
          "sisko"
          "picard"
          "kirk"
          "pike"
        ]
        {
          enable = true;
        };
    zfs =
      mkFor
        [
          "picard"
          "kirk"
          "pike"
        ]
        {
          enable = true;
        };
    restic = mkFor [ "sisko" ] {
      # https://github.com/ngosang/restic-exporter/issues/31
      enable = false;
      repository = config.services.restic.backups.sisko.repository;
      passwordFile = config.age.secrets.SISKO_RESTIC_PASSWORD.path;
    };
    postgres = mkFor [ "sisko" ] {
      enable = true;
    };
    nginx = mkFor [ "sisko" ] {
      enable = true;
    };
    smartctl =
      mkFor
        [
          "sisko"
          "picard"
          "kirk"
          "pike"
        ]
        {
          enable = true;
        };
  };

  systemd.services.prometheus-restic-exporter.path = [ pkgs.openssh ];
}
