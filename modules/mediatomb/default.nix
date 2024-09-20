{
  services.mediatomb = {
    enable = true;
    openFirewall = true;
    serverName = "Rock 5B";
    mediaDirectories = [
      {
        path = "/mnt/hd/torrent";
        recursive = true;
      }
    ];
  };

  users.users.mediatomb.extraGroups = [ "transmission" ];
}
