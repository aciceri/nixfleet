{
  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
  };
  hardware = {
    bluetooth.input.General = {
      ClassicBondedOnly = false;
    };
  };
}
