{ config, ... }:
{
  services.atuin = {
    enable = true;
    openFirewall = false; # use only in the VPN
    port = 8889;
    host = "0.0.0.0";
    openRegistration = true;
  };
  networking.firewall.interfaces."wg0" = {
    allowedTCPPorts = [
      config.services.atuin.port
    ];
  };
}
