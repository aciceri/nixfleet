{ config, lib, ... }:
{
  services.zerotierone = {
    enable = true;
    joinNetworks = [ "632ea29085af0cb4" ];
  };
  environment =
    if (config.networking.hostName == "sisko") then
      {
        persistence."/persist".directories = [
          "/var/lib/zerotier-one"
        ];
      }
    else
      { };
}
