{
  services.adguardhome = {
    enable = true;
    port = 3000;
    mutableSettings = true;
    settings = {
      openFirewall = true;
    };
  };
  networking.firewall.allowedTCPPorts = [
    3000
    53
  ];
  networking.firewall.allowedUDPPorts = [ 53 ];
  environment.persistence."/persist".directories = [
    "/var/lib/AdGuardHome"
  ];
}
