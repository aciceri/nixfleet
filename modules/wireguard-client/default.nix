{
  config,
  vpn,
  ...
}: {
  imports = [../wireguard-common];

  networking.wireguard.interfaces.wg0 = {
    ips = ["${vpn.${config.networking.hostName}.ip}/32"];
    peers = [
      {
        publicKey = vpn.sisko.publicKey;
        allowedIPs = ["10.100.0.0/24"];
        endpoint = "vpn.aciceri.dev:51820";
        persistentKeepalive = 25;
      }
    ];
  };
}
