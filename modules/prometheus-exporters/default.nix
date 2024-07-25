{
  config,
  pkgs,
  lib,
  ...
}: let
  hostname = config.networking.hostName;
  mkFor = hosts: lib.mkIf (builtins.elem hostname hosts);
in {
  services.prometheus.exporters = {
    node = mkFor ["sisko" "picard"] {
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
      extraFlags = ["--collector.ethtool" "--collector.softirqs" "--collector.tcpstat" "--collector.wifi"];
    };
    wireguard = mkFor ["sisko" "picard"] {
      enable = true;
    };
    zfs = mkFor ["picard"] {
      enable = true;
    };
    # restic = mkFor ["sisko"] {
    #   enable = true;
    # };
    postgres = mkFor ["sisko"] {
      enable = true;
    };
    nginx = mkFor ["sisko"] {
      enable = true;
    };
    smartctl = mkFor ["sisko"] {
      enable = true;
    };
  };
}
