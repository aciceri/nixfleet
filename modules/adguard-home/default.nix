{
  services.adguardhome = {
    enable = true;
    settings = {
      bind_port = 3000;
      openFirewall = true;
    };
  };
  networking.firewall.allowedTCPPorts = [3000 53];
  networking.firewall.allowedUDPPorts = [53];
}
