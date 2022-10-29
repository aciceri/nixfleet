# FIXME For some reson this doesnt' work
{
  config,
  lib,
  pkgs,
  ...
}: {
  networking.firewall = {
    allowedUDPPorts = [51820]; # Clients and peers can use the same port, see listenport
  };
  networking.wireguard.interfaces = {
    # "wg0" is the network interface name. You can name the interface arbitrarily.
    wg0 = {
      # Determines the IP address and subnet of the client's end of the tunnel interface.
      ips = ["10.100.0.2/24"];
      listenPort = 51820; # to match firewall allowedUDPPorts (without this wg uses random port numbers)

      # Path to the private key file.
      #
      # Note: The private key can also be included inline via the privateKey option,
      # but this makes the private key world-readable; thus, using privateKeyFile is
      # recommended.
      privateKeyFile = "/home/ccr/wg-private"; #TODO use agenix

      peers = [
        # For a client configuration, one peer entry for the server will suffice.

        {
          # Public key of the server (not a file path).
          publicKey = "fCwjd75CefC9A7WqO7s3xfOk2nRcoTKfnAzDT6Lc5AA=";

          # Forward all the traffic via VPN.
          allowedIPs = ["0.0.0.0/0"];
          # Or forward only particular subnets
          #allowedIPs = [ "10.100.0.1" "91.108.12.0/22" ];

          # Set this to the server IP and port.
          endpoint = "ccr.ydns.eu:51820"; # ToDo: route to endpoint not automatically configured https://wiki.archlinux.org/index.php/WireGuard#Loop_routing https://discourse.nixos.org/t/solved-minimal-firewall-setup-for-wireguard-client/7577

          # Send keepalives every 25 seconds. Important to keep NAT tables alive.
          persistentKeepalive = 25;
        }
      ];
    };
  };

  networking.wg-quick.interfaces = {
    wg0 = {
      address = ["10.0.0.2/24" "fdc9:281f:04d7:9ee9::2/64"];
      dns = ["10.0.0.1" "fdc9:281f:04d7:9ee9::1"];
      privateKeyFile = "/home/ccr/wg-private";

      peers = [
        {
          publicKey = "fCwjd75CefC9A7WqO7s3xfOk2nRcoTKfnAzDT6Lc5AA=";
          # presharedKeyFile = "/root/wireguard-keys/preshared_from_peer0_key";
          allowedIPs = ["0.0.0.0/0" "::/0"];
          endpoint = "ccr.ydns.eu:51820";
          persistentKeepalive = 25;
        }
      ];
    };
  };
}
