{
  services.mediatomb = {
    enable = true;
    openFirewall = true;
    serverName = "Sisko";
    mediaDirectories = [
      {
        path = "/mnt/hd/torrent";
        recursive = true;
      }
    ];
  };

  users.users.mediatomb.extraGroups = [ "transmission" ];
}
