{ config, lib, ... }:
{
  services.atticd = {
    enable = true;
    settings = {
      listen = "0.0.0.0:8081";
      allowed-hosts = [ ]; # Allow all hosts
      # api-endpoint = "https://cache.aciceri.dev";
      soft-delete-caches = false;
      require-proof-of-possession = true;

      database.url = "sqlite://${config.services.atticd.settings.storage.path}/server.db?mode=rwc";

      storage = {
        type = "local";
        path = "/mnt/hd/attic";
      };

      compression.type = "none";

      garbage-collection.interval = "0 hours"; # disable garbage collection

      chunking = {
        nar-size-threshold = 64 * 1024; # 64 KiB
        min-size = 16 * 1024; # 16 KiB
        avg-size = 64 * 1024; # 64 KiB
        max-size = 256 * 1024; # 256 KiB
      };
    };
    environmentFile = config.age.secrets.sisko-attic-environment-file.path;
  };

  systemd.services.atticd = {
    serviceConfig = {
      DynamicUser = lib.mkForce false;
    };
  };

  systemd.tmpfiles.rules = [
    "d config.services.atticd.settings.storage.path 770 atticd atticd"
  ];

  users = {
    groups.atticd = { };
    users.atticd = {
      group = "atticd";
      home = config.services.atticd.settings.storage.path;
      isSystemUser = true;
    };
  };
}
