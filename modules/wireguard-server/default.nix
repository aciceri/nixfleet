{
  config,
  lib,
  vpn,
  ...
}:
{
  imports = [ ../wireguard-common ];

  networking.nat.enable = true;

  networking.firewall.allowedUDPPorts = [ config.networking.wireguard.interfaces.wg0.listenPort ];

  networking.wireguard.interfaces.wg0 = {
    ips = [ "${vpn.${config.networking.hostName}.ip}/24" ];
    peers = lib.mapAttrsToList (_hostname: vpnConfig: {
      publicKey = vpnConfig.publicKey;
      allowedIPs = [ "${vpnConfig.ip}/32" ];
    }) vpn;
  };
}
