{ config, lib, ... }:
lib.mkMerge [
  {
    services.zerotierone = {
      enable = true;
      joinNetworks = [ "632ea29085af0cb4" ];
    };
  }
  (lib.optionalAttrs (config.networking.hostName == "sisko") {
    environment.persistence."/persist".directories = [
      "/var/lib/zerotier-one"
    ];
  })
]
