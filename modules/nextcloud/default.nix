{
  config,
  pkgs,
  ...
}:
{
  systemd.tmpfiles.rules = [
    "d /mnt/raid/nextcloud 770 nextcloud nextcloud"
  ];

  ccr.extraGroups = [ "nextcloud" ];

  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud26;
    database.createLocally = true;
    home = "/mnt/raid/nextcloud";
    hostName = "nextcloud.aciceri.dev";
    config = {
      adminpassFile = config.age.secrets.nextcloud-admin-pass.path;
      overwriteProtocol = "https";
    };
  };

  networking.firewall.allowedTCPPorts = [ 80 ];
}
