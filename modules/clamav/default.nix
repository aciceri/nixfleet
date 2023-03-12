{
  services.clamav = {
    daemon.enable = true;
    updater = {
      enable = true;
      frequency = 1;
      interval = "daily";
    };
  };
}
