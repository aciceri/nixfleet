{
  config,
  pkgs,
  ...
}: {
  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = ''
             monitor = DP-2, 1920x1200, 0x0, 1, transform, 3
             monitor = DP-1, 2560x1440, 1200x320, 1
             monitor = eDP-1, 1920x1080, 3760x230, 1

             exec-once = ${config.programs.waybar.package}/bin/waybar
             exec-once = ${config.services.mako.package}/bin/mako
             exec-once = ${pkgs.swaybg}/bin/swaybg ../sway/wallpaper.svg

             windowrulev2 = tile, class:^(Spotify)$
             windowrulev2 = workspace 9, class:^(Spotify)$

             bind = SUPER , F, exec, firefox
             bind = SUPER , RETURN, exec, ${config.programs.kitty.package}/bin/kitty ${config.programs.kitty.package}/bin/kitty +kitten ssh mothership.fleet
             bind = SUPER, y, exec, ${pkgs.waypipe}/bin/waypipe --compress lz4=10 ssh mothership.fleet emacsclient -c
             bind = SUPER, d, exec, ${pkgs.fuzzel}/bin/fuzzel --background-color=253559cc --border-radius=5 --border-width=0

             bind = SUPER SHIFT, q, killactive
             bind = SUPER SHIFT, f, fullscreen, 0
             bind = SUPER SHIFT, e, exit

             bind = SUPER, h, movefocus, l
             bind = SUPER, l, movefocus, r
             bind = SUPER, k, movefocus, u
             bind = SUPER, j, movefocus, d

             bind = SUPER SHIFT, h, movewindow, l
             bind = SUPER SHIFT, l, movewindow, r
             bind = SUPER SHIFT, k, movewindow, u
             bind = SUPER SHIFT, j ,movewindow, d

             bind = SUPER, p, movecurrentworkspacetomonitor, r
             bind = SUPER, o, movecurrentworkspacetomonitor, l

             bind = SUPER, 1, workspace, 1
      bind = SUPER, 2, workspace, 2
      bind = SUPER, 3, workspace, 3
      bind = SUPER, 4, workspace, 4
      bind = SUPER, 5, workspace, 5
      bind = SUPER, 6, workspace, 6
      bind = SUPER, 7, workspace, 7
      bind = SUPER, 8, workspace, 8
      bind = SUPER, 9, workspace, 9
      bind = SUPER, 0, workspace, 10

      bind = SUPER SHIFT, 1, movetoworkspace, 1
      bind = SUPER SHIFT, 2, movetoworkspace, 2
      bind = SUPER SHIFT, 3, movetoworkspace, 3
      bind = SUPER SHIFT, 4, movetoworkspace, 4
      bind = SUPER SHIFT, 5, movetoworkspace, 5
      bind = SUPER SHIFT, 6, movetoworkspace, 6
      bind = SUPER SHIFT, 7, movetoworkspace, 7
      bind = SUPER SHIFT, 8, movetoworkspace, 8
      bind = SUPER SHIFT, 9, movetoworkspace, 9
      bind = SUPER SHIFT, 0, movetoworkspace, 10

      decoration {
          # See https://wiki.hyprland.org/Configuring/Variables/ for more

          rounding = 4
          blur = true
          blur_size = 3
          blur_passes = 1
          blur_new_optimizations = true

          drop_shadow = true
          shadow_range = 4
          shadow_render_power = 3
          col.shadow = rgba(1a1a1aee)
      }

      animations {
          enabled = true

          # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

          bezier = myBezier, 0.05, 0.9, 0.1, 1.05

          animation = windows, 1, 7, myBezier
          animation = windowsOut, 1, 7, default, popin 80%
          animation = border, 1, 10, default
          animation = borderangle, 1, 8, default
          animation = fade, 1, 7, default
          animation = workspaces, 1, 6, default
      }
    '';
  };
}
