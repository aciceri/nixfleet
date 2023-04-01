{config, ...}: {
  networking.firewall = {
    allowedUDPPorts = [51820]; # Clients and peers can use the same port, see listenport
  };
  # Enable WireGuard
  networking.wireguard.interfaces = {
    # "wg0" is the network interface name. You can name the interface arbitrarily.
    wg0 = {
      ips = ["10.100.0.2/32"];
      listenPort = 51820; # to match firewall allowedUDPPorts (without this wg uses random port numbers)

      privateKeyFile = config.age.secrets."${config.networking.hostName}-wireguard-private-key".path;

      peers = [
        {
          # Public key of the server (not a file path).
          publicKey = "O9V2PI7+vZm7gGn3f9SaTsJbVe9urf/jZkdXFz/mjVU=";

          # Forward all the traffic via VPN.
          # allowedIPs = [ "0.0.0.0/0" ];
          # Or forward only particular subnets
          allowedIPs = ["10.100.0.1"];

          # Set this to the server IP and port.
          endpoint = "mothership.aciceri.dev:51820";

          persistentKeepalive = 25;
        }
      ];
    };
  };
}
