let
  wallpaper = ./wallpaper.png;
in {
  xdg.configFile."hypr/hyprpaper.conf".text = ''
    preload = ${wallpaper}
    wallpaper = eDP-1,${wallpaper}
    wallpaper = DP-1,${wallpaper}
    wallpaper = DP-2,${wallpaper}
    wallpaper = HDMI-A-1,${wallpaper}
  '';
}
