{
  config,
  pkgs,
  lib,
  ...
}: let
  screenshotScript = pkgs.writeShellScript "screenshot.sh" ''
    filename="$HOME/shots/$(date --iso-8601=seconds).png"
    coords="$(${pkgs.slurp}/bin/slurp)"
    ${pkgs.grim}/bin/grim -t png -g "$coords" "$filename"
    wl-copy -t image/png < $filename
  '';
  hyprland = config.wayland.windowManager.hyprland.package;
  switchMonitorScript = pkgs.writeShellScript "switch-monitor.sh" ''
    if [[ "$(${hyprland}/bin/hyprctl monitors) | grep '\sDP-[0-9]+'" ]]; then
      if [[ $1 == "open" ]]; then
        ${hyprland}/bin/hyprctl keyword monitor "eDP-1,1920x1080,3760x230,1"
      else
        ${hyprland}/bin/hyprctl keyword monitor "eDP-1,disable"
      fi
    fi
  '';
in {
  imports = [
    ./hyprpaper.nix
    ../waybar
    ../swayidle
    # ../mako
    ../swaync
    ../gammastep
    # ../kitty
    ../wezterm
  ];

  home.packages = with pkgs; [wl-clipboard waypipe];

  systemd.user.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  services.network-manager-applet.enable = true;
  services.blueman-applet.enable = true;
  services.pasystray.enable = true;
  xsession.enable = true;

  services.udiskie.enable = true;

  gtk = {
    enable = true;
    font.name = "Sans,Symbols Nerd Font";
    iconTheme = {
      name = "Adwaita";
      package = pkgs.gnome.adwaita-icon-theme;
    };
  };

  services.kanshi = {
    enable = true;
    systemdTarget = "hyprland-session.target";
    profiles = {
      undocked = {
        outputs = [
          {
            status = "enable";
            criteria = "eDP-1";
          }
        ];
      };
      docked = {
        outputs = [
          {
            status = "disable";
            criteria = "eDP-1";
          }
          {
            status = "enable";
            criteria = "DP-1";
          }
        ];
      };
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = ''
             input {
               touchpad {
                 disable_while_typing = true # set to true while playing
               }
             }

             monitor = HDMI-A-1, 2560x1440, 0x0, 1 # picard
             monitor = eDP-1, 1920x1080, 0x0, 1 # kirk

             bindl=,switch:off:Lid Switch,exec,${switchMonitorScript} open
             bindl=,switch:on:Lid Switch,exec,${switchMonitorScript} close

             exec-once = ${pkgs.hyprpaper}/bin/hyprpaper

             windowrulev2 = tile, class:^(Spotify)$
             windowrulev2 = workspace 9, class:^(Spotify)$
             windowrulev2 = tile, class:^(fluffychat)$
             windowrulev2 = workspace 8, class:^(fluffychat)$
             windowrulev2 = tile, class:^(WhatsApp for Linux)$
             windowrulev2 = workspace 7, class:^(WhatsApp for Linux)$
             windowrulev2 = float, title:^(floating)$

             bind = SUPER, b, exec, firefox
             bind = SUPER SHIFT, b , exec, ${pkgs.waypipe}/bin/waypipe --compress lz4=10 ssh mothership.fleet firefox
             bind = SUPER SHIFT, RETURN, exec, ${config.programs.wezterm.package}/bin/wezterm ssh mothership.fleet
             bind = SUPER, m, exec, ${config.programs.wezterm.package}/bin/wezterm start -- mosh mothership.fleet
             bind = SUPER, t, exec, ${config.programs.wezterm.package}/bin/wezterm
             bind = SUPER, RETURN, exec, emacsclient -c --eval "(ccr/start-eshell)"
             bind = SUPER, x, exec, emacsclient -c
             bind = SUPER SHIFT, n, exec, emacsclient --eval '(ccr/org-capture "n")' -c -F '((name . "floating"))'
             bind = SUPER SHIFT, w, exec, emacsclient --eval '(ccr/org-capture "j")' -c -F '((name . "floating"))'
             bind = SUPER, y, exec, ${pkgs.waypipe}/bin/waypipe --compress lz4=10 ssh picard.fleet emacsclient -c
             bind = SUPER, d, exec, ${pkgs.fuzzel}/bin/fuzzel --background-color=253559cc --border-radius=5 --border-width=0
             bind = SUPER, s, exec, ${screenshotScript}
             bind = , XF86MonBrightnessUp, exec, ${pkgs.brightnessctl}/bin/brightnessctl s +5%
             bind = , XF86MonBrightnessDown, exec, ${pkgs.brightnessctl}/bin/brightnessctl s 5%-
             bind = SUPER, code:60, exec, ${pkgs.brightnessctl}/bin/brightnessctl s +5%
             bind = SUPER, code:59, exec, ${pkgs.brightnessctl}/bin/brightnessctl s 5%-
      bind = SUPER SHIFT, t, exec, ${config.services.swaync.package}/bin/swaync-client -t


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

             bindm=ALT,mouse:272,movewindow

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

             general {
               gaps_in = 0
               gaps_out = 0
               border_size = 1
        col.active_border = rgba(AF8D61FF) rgba(CEB153FF) rgba(7B8387FF) 45deg
               col.inactive_border = rgba(AF8D6166)
             }

             decoration {
                 # See https://wiki.hyprland.org/Configuring/Variables/ for more

                 rounding = 2
                 # blur = true
                 # blur_size = 8
                 # blur_passes = 1
                 # blur_new_optimizations = true

                 drop_shadow = true
                 shadow_range = 4
                 shadow_render_power = 3
                 col.shadow = rgba(a8cfee11)
             }

             animations {
                 enabled = true

                 # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

                 bezier = myBezier, 0.05, 0.9, 0.1, 1.05

                 animation = windows, 1, 3, myBezier
                 animation = windowsOut, 1, 3, default, popin 80%
                 animation = border, 1, 5, default
                 animation = borderangle, 1, 4, default
                 animation = fade, 1, 3, default
                 animation = workspaces, 1, 3, default
             }
    '';
  };
}
