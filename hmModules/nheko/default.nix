{ pkgs, ... }:
{
  home.packages = [ pkgs.nheko ];

  # systemd.user.services.nheko = {
  #   Install.WantedBy = ["graphical-session.target"];

  #   Unit = {
  #     Description = "Nheko";
  #     PartOf = ["graphical-session.target"];
  #   };

  #   Service = {
  #     ExecStart = "${pkgs.nheko}/bin/nheko";
  #     Restart = "on-failure";
  #     RestartSec = 3;
  #   };
  # };
}
