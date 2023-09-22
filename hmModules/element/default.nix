{pkgs, ...}: {
  home.packages = [pkgs.schildichat-desktop];

  systemd.user.services.element-desktop = {
    Install.WantedBy = ["graphical-session.target"];

    Unit = {
      Description = "Element";
      PartOf = ["graphical-session.target"];
    };

    Service = {
      ExecStart = "${pkgs.schildichat-desktop}/bin/schildichat-desktop";
      Restart = "on-failure";
      RestartSec = 3;
    };
  };
}
