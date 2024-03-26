{
  services.jellyfin = {
    enable = true;
  };

  users.users.jellyfin.extraGroups = ["transmission"];
}
