{pkgs, ...}: {
  home.packages = [pkgs.franz];

  systemd.user.services.franz = {
    Install.WantedBy = ["graphical-session.target"];

    Unit = {
      Description = "Franz";
      PartOf = ["graphical-session.target"];
    };

    Service = {
      ExecStart = "${pkgs.franz}/bin/franz";
      Restart = "on-failure";
      RestartSec = 3;
    };
  };
}
