{ config, lib, ... }:
{
  users.users.amule = {
    isSystemUser = true;
    group = "amule";
    extraGroups = [ "amule" ];
    home = config.services.amule.dataDir;
  };

  users.groups.amule = { };
  services.amule = {
    dataDir = "/mnt/hd/amule";
    enable = true;
    user = "amule";
  };

  # sometimes the service crashes with a segfeault without any reason...
  systemd.services.amuled.serviceConfig.Restart = lib.mkForce "always";

  environment.persistence."/persist".directories = [
    config.services.amule.dataDir
  ];

  networking.firewall = {
    allowedTCPPorts = [ 4662 ];
    allowedUDPPortRanges = [
      {
        from = 4665;
        to = 4672;
      }
    ];
  };

}
