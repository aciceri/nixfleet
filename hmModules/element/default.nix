{ pkgs, lib, ... }:
{
  home.packages = [ pkgs.element-desktop ];

  systemd.user.services.element-desktop = {
    Install.WantedBy = [ "graphical-session.target" ];

    Unit = {
      Description = "Element";
      PartOf = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = lib.getExe pkgs.element-desktop;
      Restart = "on-failure";
      RestartSec = 3;
    };
  };
}
