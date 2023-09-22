{pkgs, ...}: let
  spotify-adblock = pkgs.nur.repos.nltch.spotify-adblock;
in {
  home.packages = [spotify-adblock];

  systemd.user.services.spotify-adblocked = {
    Install.WantedBy = ["graphical-session.target"];

    Unit = {
      Description = "Spotify";
      PartOf = ["graphical-session.target"];
    };

    Service = {
      ExecStart = "${spotify-adblock}/bin/spotify";
      Restart = "on-failure";
      RestartSec = 3;
    };
  };
}
