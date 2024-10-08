{
  pkgs,
  lib,
  ...
}:
{
  home.packages = [ pkgs.zmkBATx ];

  systemd.user.services.zmkBATx = {
    Install.WantedBy = [
      "waybar.service"
    ];

    Unit = {
      Description = "zmkBATx";
    };

    Service = {
      ExecStart = ''
        ${pkgs.runtimeShell} -l -c "${lib.getExe' pkgs.busybox "sleep"} 5 && ${lib.getExe pkgs.zmkBATx}"
      '';
      Restart = "on-failure";
      RestartSec = 3;
    };
  };
}
