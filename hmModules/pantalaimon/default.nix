{ pkgs, lib, ... }:
{
  services.pantalaimon = {
    enable = true;
    package = pkgs.pantalaimon.overrideAttrs {
      pytestCheckPhase = "echo skip pytest";
    };
    settings = {
      Default = {
        LogLevel = "Debug";
        SSL = true;
      };
      local-matrix = {
        Homeserver = "https://matrix.aciceri.dev";
        # Homeserver = "https://matrix.nixos.dev/_matrix/client";
        # Homeserver = "https://matrix.nixos.dev";
        ListenAddress = "localhost";
        ListenPort = 8008;
        # SSL = false;
        UseKeyring = false;
        # IgnoreVerification = true;
      };
    };
  };

  systemd.user.services.pantalaimon.Unit.Requires = [ "dbus.socket" ];
}
