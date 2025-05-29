{
  config,
  vpn,
  ...
}:
{
  imports = [ ../wireguard-common ];

  networking.wireguard.interfaces.wg0 = {
    mtu = 1200;
    ips = [ "${vpn.${config.networking.hostName}.ip}/32" ];
    peers = [
      {
        publicKey = vpn.sisko.publicKey;
        allowedIPs = [ "10.100.0.0/24" ];
        # allowedIPs = [ "0.0.0.0/24" ]; # Uncomment for full tunnel
        endpoint = "vpn.aciceri.dev:51820";
        persistentKeepalive = 25;
      }
    ];
  };
}
