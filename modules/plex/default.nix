{
  services.plex = {
    enable = true;
    openFirewall = true;
    dataDir = "/mnt/raid/plex";
  };

  systemd.tmpfiles.rules = [
    "d /mnt/raid/plex 770 plex plex"
  ];

  users.users.plex.extraGroups = ["transmission"];
}
