{
  pkgs,
  lib,
  ...
}: {
  home.packages = [pkgs.zmkBATx];

  systemd.user.services.zmkBATx = {
    Install.WantedBy = ["graphical-session.target" "waybar.service"];

    Unit = {
      Description = "zmkBATx";
    };

    Service = {
      ExecStart = lib.getExe pkgs.zmkBATx;
      Restart = "on-failure";
      RestartSec = 3;
    };
  };
}
