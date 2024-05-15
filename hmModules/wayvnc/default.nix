{
  pkgs,
  lib,
  vpn,
  hostname,
  ...
}: {
  systemd.user.services.wayvnc = {
    Install.WantedBy = ["graphical-session.target"];

    Unit = {
      Description = "WayVNC";
      PartOf = ["graphical-session.target"];
    };

    Service = {
      ExecStart = "${lib.getExe pkgs.wayvnc "wayvnc"} ${vpn.${hostname}.ip} 5900";
      Restart = "on-failure";
      RestartSec = 3;
    };
  };
}
