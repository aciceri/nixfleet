{ config, ... }:
{
  networking.wireguard.interfaces.wg1 = {
    ips = [ "10.10.1.1/32" ];
    peers = [
      {
        publicKey = "A4u2Rt5WEMHOAc6YpDABkqAy2dzzFLH9Gn8xWcKaPQQ=";
        allowedIPs = [ "10.10.0.0/16" ];
        endpoint = "vpn.staging.mlabs.city:51820";
        persistentKeepalive = 25;
      }
    ];
    privateKeyFile = config.age.secrets.wireguard-mlabs-private-key.path;
    mtu = 1300;
  };
}
