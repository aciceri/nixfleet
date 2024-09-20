{
  lib,
  ...
}:
let
  originalConfig = config.wayland.windowManager.hyprland.extraConfig;
  config = builtins.replaceStrings [ "SUPER" ] [ "" ] originalConfig;
in
{
  systemd.user.services.headless-hyprland = {
    Unit.Description = "Headless Hyprland";
    Service = {
      Type = "oneshot";
      ExecStart = ''
        ${lib.getExe config.wayland.windowManager.hyprland.package} --config ${config}
      '';
    };
  };
}
