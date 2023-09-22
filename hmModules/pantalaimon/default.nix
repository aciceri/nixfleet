{
  services.pantalaimon = {
    enable = true;
    settings = {
      local-matrix = {
        Homeserver = "https://nixos.dev";
        ListenAddress = "127.0.0.1";
        ListenPort = 8008;
      };
    };
  };
  systemd.user.services.pantalaimon.Unit.Requires = ["dbus.socket"];
}
