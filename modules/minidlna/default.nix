{config, ...}: {
  services.minidlna = {
    enable = true;
    openFirewall = true;
    settings = {
      friendly_name = config.networking.hostName;
      inotify = "yes";
      media_dir = [
        "/mnt/raid"
      ];
    };
  };

  systemd.tmpfiles.rules = [
    "d /mnt/raid/film 770 minidlna minidlna"
  ];

  ccr.extraGroups = ["minidlna"];
}
