{config, ...}: {
  services.transmission = {
    enable = true;
    openRPCPort = true;
    openPeerPorts = true;
    settings = {
      download-dir = "/mnt/raid/torrent";
      incomplete-dir = "/mnt/raid/torrent/.incomplete";

      rpc-bind-address = "0.0.0.0";
      peer-port = 51413; # Forward both TCP and UDP on router traffic from router
      rpc-whitelist-enabled = false;
      rpc-host-whitelist-enabled = false;

      rpc-authentication-required = true;
      rpc-username = "andrea";
      # Generated with https://github.com/tomwijnroks/transmission-pwgen
      rpc-password = "{9d03dda3243ebddfa44b0bebe099f611941e2fc31/0vvwdP";

      upload-slots-per-torrent = 1000;

      alt-speed-up = 1000; # 1MB/s
      alt-speed-down = 2000; # 3MB/s
      alt-speed-time-enabled = true;
      alt-speed-time-begin = 540; # 9AM, minutes after midnight
      alt-speed-time-end = 1380; # 11PM
      alt-speed-time-day = 127; # all days, bitmap, 0111110 is weekends and 1000001 is weekdays

      ratio-limit-enabled = true;
      ratio-limit = 2;
    };
  };

  networking.firewall.allowedTCPPorts = [
    config.services.transmission.settings.rpc-port
  ];

  systemd.tmpfiles.rules = [
    "d /mnt/raid/torrent 770 transmission transmission"
    "d /mnt/raid/torrent/.incomplete 770 transmission transmission"
  ];

  ccr.extraGroups = ["transmission"];
}
