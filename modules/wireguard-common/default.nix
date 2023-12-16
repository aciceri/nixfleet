{
  lib,
  config,
  vpn,
  ...
}: {
  networking.firewall.interfaces.wg0 = {
    allowedUDPPortRanges = [
      {
        from = 0;
        to = 65535;
      }
    ];
    allowedTCPPortRanges = [
      {
        from = 0;
        to = 65535;
      }
    ];
  };

  networking.wireguard.interfaces.wg0 = {
    privateKeyFile = config.age.secrets."${config.networking.hostName}-wireguard-private-key".path;
    listenPort = 51820;
  };

  networking.hosts =
    lib.mapAttrs'
    (hostname: vpnConfig: {
      name = vpnConfig.ip;
      value = ["${hostname}.fleet"];
    })
    vpn;
}
