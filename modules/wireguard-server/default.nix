{
  pkgs,
  config,
  ...
}: {
  networking.nat.enable = true;
  networking.nat.externalInterface = "enp5s0"; # mothership network interface, shouldn't be hardcoded here
  networking.nat.internalInterfaces = ["wg0"];
  networking.firewall = {
    allowedUDPPorts = [51820];
  };

  networking.wireguard.interfaces = {
    wg0 = {
      ips = ["10.100.0.1/24"];

      listenPort = 51820;

      postSetup = ''
        ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.100.0.0/24 -o eth0 -j MASQUERADE
      '';

      postShutdown = ''
        ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.100.0.0/24 -o eth0 -j MASQUERADE
      '';

      privateKeyFile = config.age.secrets."${config.networking.hostName}-wireguard-private-key".path;

      peers = [
        {
          # thinkpad
          publicKey = "g8wId6Rl0olRFRtAnQ046ihPRYFCtMxOJ+/Z9ARwIxI=";
          # List of IPs assigned to this peer within the tunnel subnet. Used to configure routing.
          allowedIPs = ["10.100.0.2/32"];
        }
      ];
    };
  };
}