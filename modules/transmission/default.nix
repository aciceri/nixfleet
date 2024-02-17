{config, ...}: {
  services.transmission = {
    enable = true;
    openRPCPort = true;
    openPeerPorts = true;
    # FIXME remove after https://github.com/NixOS/nixpkgs/issues/279049
    webHome = "${config.services.transmission.package}/share/transmission/web";
    settings = {
      download-dir = "/mnt/hd/torrent";
      incomplete-dir = "/mnt/hd/torrent/.incomplete";

      rpc-bind-address = "0.0.0.0";
      peer-port = 51413; # Forward both TCP and UDP on router traffic from router
      rpc-whitelist-enabled = false;
      rpc-host-whitelist-enabled = false;

      rpc-authentication-required = true;
      rpc-username = "andrea";
      # Generated with https://github.com/tomwijnroks/transmission-pwgen
      rpc-password = "{9d03dda3243ebddfa44b0bebe099f611941e2fc31/0vvwdP";

      upload-slots-per-torrent = 1000;

      alt-speed-up = 300000; # 300MB/s
      alt-speed-down = 500000; # 500MB/s
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
    "d /mnt/hd/torrent 770 transmission transmission"
    "d /mnt/hd/torrent/.incomplete 770 transmission transmission"
  ];

  ccr.extraGroups = ["transmission"];
}
