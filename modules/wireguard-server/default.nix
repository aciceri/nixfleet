{
  config,
  lib,
  vpn,
  pkgs,
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

    postSetup = ''
      ${lib.getExeo' pkgs.iptables "iptables"} -t nat -A POSTROUTING -s 10.100.0.0/24 -o enP4p65s0 -j MASQUERADE
    '';

    postShutdown = ''
      ${lib.getExe' pkgs.iptables "iptables"} -t nat -D POSTROUTING -s 10.100.0.0/24 -o enP4p65s0 -j MASQUERADE
    '';
  };
}
