{ pkgs, ... }:
{
  # home.packages = [pkgs.schildichat-desktop];
  home.packages = [ pkgs.element-desktop-wayland ];

  systemd.user.services.element-desktop = {
    Install.WantedBy = [ "graphical-session.target" ];

    Unit = {
      Description = "Element";
      PartOf = [ "graphical-session.target" ];
    };

    Service = {
      # ExecStart = "${pkgs.schildichat-desktop}/bin/schildichat-desktop"; # TODO I preferred SchildiChat but it was removed from nixpkgs becuase unsafe
      ExecStart = "${pkgs.element-desktop-wayland}/bin/element-desktop";
      Restart = "on-failure";
      RestartSec = 3;
    };
  };
}
