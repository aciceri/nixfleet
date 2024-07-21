{
  config,
  pkgs,
  ...
}: {
  services.prometheus.exporters.node = {
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
}
