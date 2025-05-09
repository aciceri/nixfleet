{
  pkgs,
  lib,
  ...
}:
{
  home.packages = [ pkgs.tremotesf ];

  systemd.user.services.tremotesf = {
    Install.WantedBy = [
      "waybar.service"
    ];

    Unit = {
      Description = "tremotesf";
    };

    Service = {
      ExecStart = pkgs.writeShellScript "start-tremotesf.sh" ''
        sleep 5
        ${lib.getExe pkgs.tremotesf} --minimized
      '';
      Restart = "on-failure";
      RestartSec = 3;
    };
  };
}
