{
  services.adguardhome = {
    enable = true;
    port = 3000;
    settings = {
      openFirewall = true;
    };
  };
  networking.firewall.allowedTCPPorts = [
    3000
    53
  ];
  networking.firewall.allowedUDPPorts = [ 53 ];
}
