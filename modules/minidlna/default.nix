{config, ...}: {
  services.minidlna = {
    enable = true;
    openFirewall = true;
    settings = {
      friendly_name = config.networking.hostName;
      inotify = "yes";
      media_dir = [
        "/mnt/torrent"
      ];
    };
  };

  ccr.extraGroups = ["minidlna"];
  users.users.minidlna.extraGroups = ["transmission"];
}
