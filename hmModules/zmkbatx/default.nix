{
  pkgs,
  lib,
  ...
}: {
  home.packages = [pkgs.zmkBATx];

  systemd.user.services.zmkBATx = {
    Install.WantedBy = ["graphical-session.target"];

    Unit = {
      Description = "zmkBATx";
      PartOf = ["graphical-session.target"];
    };

    Service = {
      ExecStart = lib.getExe pkgs.zmkBATx;
      Restart = "on-failure";
      RestartSec = 3;
    };
  };
}
