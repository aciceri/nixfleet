{
  config,
  lib,
  pkgs,
  ...
}: {
  services.transmission = {
    enable = true;
    settings = {
      rpc-port = 9091;
      rpc-whitelist-enabled = false;
      rpc-host-whitelist-enabled = false;
    };
  };

  users.users.ccr.extraGroups = ["transmission"];
}
