{
  config,
  lib,
  vpn,
  ...
}: {
  imports = [../wireguard-common];

  networking.nat.enable = true;

  networking.firewall.allowedUDPPorts = [config.networking.wireguard.interfaces.wg0.listenPort]; # FIXME move this to wireguard-server

  networking.wireguard.interfaces.wg0 = {
    ips = ["${vpn.${config.networking.hostName}.ip}/24"];
    peers =
      lib.mapAttrsToList (hostname: vpnConfig: {
        publicKey = vpnConfig.publicKey;
        allowedIPs = ["${vpnConfig.ip}/32"];
      })
      vpn;
  };
}
