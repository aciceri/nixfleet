{ pkgs, lib, ... }:
{
  systemd.services.dump1090-fa = {
    description = "dump1090 ADS-B receiver (FlightAware customization)";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      DynamicUser = true;
      SupplementaryGroups = "plugdev";
      ExecStart = lib.escapeShellArgs [
        (lib.getExe pkgs.dump1090)
        "--net"
        "--write-json"
        "%t/dump1090-fa"
      ];
      RuntimeDirectory = "dump1090-fa";
      WorkingDirectory = "%t/dump1090-fa";
      RuntimeDirectoryMode = 755;
    };
  };

  services.nginx = {
    enable = true;

    virtualHosts."dump1090-fa" = {
      listen = [
        {
          addr = "0.0.0.0";
          port = 8080;
        }
      ];
      locations = {
        "/".alias = "${pkgs.dump1090}/share/dump1090/";
        "/data/".alias = "/run/dump1090-fa/";
      };
    };
  };

  # TODO before upstreaming in nixpkgs
  # - add `meta.mainProgram` to dump1090
  # - rename dump1090 to dump1090-fa
  # - optionally create an alias for dump1090
  # - securing the systemd service (`systemd-analyze security dump1090-fa`)
}
