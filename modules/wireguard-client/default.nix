{
  config,
  vpn,
  ...
}: {
  imports = [../wireguard-common];

  networking.wireguard.interfaces.wg0 = {
    ips = ["${vpn.${config.networking.hostName}.ip}/32"];
    # TODO having two peers like this a good idea? (they are the same host)
    peers = [
      {
        publicKey = vpn.sisko.publicKey; # FIXME hardcoding `sisko` here
        allowedIPs = ["10.100.0.0/24"];
        endpoint = "vpn.aciceri.dev:51820";
        persistentKeepalive = 25;
      }
      {
        publicKey = vpn.sisko.publicKey; # FIXME hardcoding `sisko` here
        allowedIPs = ["10.100.0.0/24"];
        endpoint = "10.1.1.2:51820";
        persistentKeepalive = 25;
      }
    ];
  };
}
