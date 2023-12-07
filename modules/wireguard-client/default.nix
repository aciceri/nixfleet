{
  config,
  fleetFlake,
  ...
}: {
  networking.firewall = {
    allowedUDPPorts = [51820];
  };
  networking.firewall.trustedInterfaces = ["wg0"];
  networking.wireguard.interfaces = {
    wg0 = {
      ips = ["${(import "${fleetFlake}/lib").ips."${config.networking.hostName}"}/32"];
      listenPort = 51820;

      privateKeyFile = config.age.secrets."${config.networking.hostName}-wireguard-private-key".path;

      peers = [
        {
          publicKey = "O9V2PI7+vZm7gGn3f9SaTsJbVe9urf/jZkdXFz/mjVU=";
          allowedIPs = ["10.100.0.0/24"];
          endpoint = "mothership.aciceri.dev:51820";
          persistentKeepalive = 25;
        }
      ];
    };
  };
}
