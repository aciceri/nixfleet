{
  services.mediatomb = {
    enable = true;
    openFirewall = true;
    serverName = "Sisko";
    mediaDirectories = [
      {
        path = "/mnt/hd/movies";
        recursive = true;
      }
      {
        path = "/mnt/hd/series";
        recursive = true;
      }
    ];
  };

  users.users.mediatomb.extraGroups = [
    "radarr"
    "sonarr"
  ];
}
