{
  pkgs,
  config,
  fleetFlake,
  lib,
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

      peers = let
        publicKeys = {
          thinkpad = "g8wId6Rl0olRFRtAnQ046ihPRYFCtMxOJ+/Z9ARwIxI=";
          oneplus6t = "O6/tKaA8Hs7OEqi15hV4RwviR6vyCTMYv6ZlhsI+tnI=";
          rock5b = "bc5giljukT1+ChbbyTLdOfejfR3c8RZ4XoXmQM54nTY=";
          pbp = "jvfAfQ2ykBndpnoLQTBJzDOhpjMOtIyCufEw+BxMxSc=";
        };
        mkPeer = hostname: {
          publicKey = publicKeys."${hostname}";
          allowedIPs = ["${(import "${fleetFlake}/lib").ips."${hostname}"}/32"];
        };
      in
        builtins.map mkPeer (lib.mapAttrsToList (hostname: _: hostname) publicKeys);
    };
  };
}
