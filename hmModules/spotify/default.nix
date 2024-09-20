{
  lib,
  pkgs,
  ...
}:
let
  spotify-adblocked = pkgs.callPackage ../../packages/spotify-adblocked { };
in
{
  home.packages = [ spotify-adblocked ];

  systemd.user.services.spotify-adblocked = {
    Install.WantedBy = [ "graphical-session.target" ];

    Unit = {
      Description = "Spotify";
      PartOf = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = lib.getExe spotify-adblocked;
      Restart = "on-failure";
      RestartSec = 3;
    };
  };
}
