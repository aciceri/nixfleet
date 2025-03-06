{
  pkgs,
  lib,
  ...
}:
let
  sessions = builtins.concatStringsSep ":" [
    # (pkgs.writeTextFile {
    #   name = "xorg-session.desktop";
    #   destination = "/hyprland-session.desktop";
    #   text = ''
    #     [Desktop Entry]
    #     Name=Hyprland
    #     Exec=Hyprland
    #   '';
    # })
    # (pkgs.writeTextFile {
    #   name = "xorg-session.desktop";
    #   destination = "/cosmic-session.desktop";
    #   text = ''
    #     [Desktop Entry]
    #     Name=Cosmic
    #     Exec=cosmic-session
    #   '';
    # })
    (pkgs.writeTextFile {
      name = "xorg-session.desktop";
      destination = "/niri-session.desktop";
      text = ''
        [Desktop Entry]
        Name=Niri
        Exec=${lib.getExe' pkgs.niri "niri-session"}
      '';
    })
  ];
in
{
  services.greetd = {
    enable = true;
    vt = 2;
    settings = {
      default_session = {
        command = lib.concatStringsSep " " [
          (lib.getExe pkgs.greetd.tuigreet)
          "--time"
          "--remember"
          "--remember-user-session"
          "--asterisks"
          # "--power-shutdown '${pkgs.systemd}/bin/systemctl shutdown'"
          "--sessions '${sessions}'"
        ];
        user = "greeter";
      };
    };
  };
}
