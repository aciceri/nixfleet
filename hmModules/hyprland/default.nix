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
    ../gammastep
    # ../wezterm
    ../wayvnc
    ../swaync
    ../foot
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
      package = pkgs.adwaita-icon-theme;
    };
    cursorTheme = {
      name = "catppuccin-mocha-sapphire";
      package = pkgs.catppuccin-cursors;
      size = 48;
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk3";
  };

  # services.kanshi = {
  #   enable = true;
  #   systemdTarget = "hyprland-session.target";
  #   profiles = {
  #     undocked = {
  #       outputs = [
  #         {
  #           status = "enable";
  #           criteria = "eDP-1";
  #         }
  #       ];
  #     };
  #     docked = {
  #       outputs = [
  #         {
  #           status = "disable";
  #           criteria = "eDP-1";
  #         }
  #         {
  #           status = "enable";
  #           criteria = "DP-1";
  #         }
  #       ];
  #     };
  #   };
  # };

  home.file.".icons/catppuccin-mocha-sapphire" = {
    source = "${pkgs.catppuccin-cursors.mochaSapphire}/share/icons/catppuccin-mocha-sapphire-cursors";
    recursive = true;
  };

  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = ''
           cursor {
      hide_on_key_press = true
      enable_hyprcursor = true
      zoom_rigid = true
           }

           env = HYPRCURSOR_THEME,catppuccin-mocha-sapphire
           env = HYPRCURSOR_SIZE,48
           env = XCURSOR_THEME,catppuccin-mocha-sapphire
           env = XCURSOR_SIZE,48

           $mod = SUPER

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
           windowrulev2 = float, title:^(floating)$

           bind = $mod, b, exec, firefox
           bind = $mod, t, exec, footclient
           bind = $mod, RETURN, exec, emacsclient -c --eval "(ccr/start-eshell)"
           bind = $mod SHIFT, g, exec, emacsclient -c --eval "(ccr/start-chatgpt)"
           bind = $mod, x, exec, emacsclient -c
           bind = $mod SHIFT, n, exec, emacsclient --eval '(ccr/org-capture "n")' -c -F '((name . "floating"))'
           bind = $mod SHIFT, w, exec, emacsclient --eval '(ccr/org-capture "j")' -c -F '((name . "floating"))'
           bind = $mod, y, exec, ${pkgs.waypipe}/bin/waypipe --compress lz4=10 ssh picard.fleet emacsclient -c
           bind = $mod, d, exec, ${pkgs.fuzzel}/bin/fuzzel --background-color=253559cc --border-radius=5 --border-width=0
           bind = $mod, s, exec, ${screenshotScript}
           bind = , XF86MonBrightnessUp, exec, ${pkgs.brightnessctl}/bin/brightnessctl s +5%
           bind = , XF86MonBrightnessDown, exec, ${pkgs.brightnessctl}/bin/brightnessctl s 5%-
           bind = $mod, code:60, exec, ${pkgs.brightnessctl}/bin/brightnessctl s +5%
           bind = $mod, code:59, exec, ${pkgs.brightnessctl}/bin/brightnessctl s 5%-

           bind = $mod SHIFT, t, togglegroup
           bind = $mod, G, changegroupactive
           bind = $mod SHIFT, q, killactive
           bind = $mod SHIFT, f, fullscreen, 0
           bind = $mod SHIFT, e, exit

           bind = $mod, h, movefocus, l
           bind = $mod, l, movefocus, r
           bind = $mod, k, movefocus, u
           bind = $mod, j, movefocus, d

           bind = $mod SHIFT, h, movewindow, l
           bind = $mod SHIFT, l, movewindow, r
           bind = $mod SHIFT, k, movewindow, u
           bind = $mod SHIFT, j ,movewindow, d

           bind = $mod, p, movecurrentworkspacetomonitor, r
           bind = $mod, o, movecurrentworkspacetomonitor, l

           bindm=ALT,mouse:272,movewindow

           bind = $mod, 1, workspace, 1
           bind = $mod, 2, workspace, 2
           bind = $mod, 3, workspace, 3
           bind = $mod, 4, workspace, 4
           bind = $mod, 5, workspace, 5
           bind = $mod, 6, workspace, 6
           bind = $mod, 7, workspace, 7
           bind = $mod, 8, workspace, 8
           bind = $mod, 9, workspace, 9
           bind = $mod, 0, workspace, 10

           bind = $mod SHIFT, 1, movetoworkspace, 1
           bind = $mod SHIFT, 2, movetoworkspace, 2
           bind = $mod SHIFT, 3, movetoworkspace, 3
           bind = $mod SHIFT, 4, movetoworkspace, 4
           bind = $mod SHIFT, 5, movetoworkspace, 5
           bind = $mod SHIFT, 6, movetoworkspace, 6
           bind = $mod SHIFT, 7, movetoworkspace, 7
           bind = $mod SHIFT, 8, movetoworkspace, 8
           bind = $mod SHIFT, 9, movetoworkspace, 9
           bind = $mod SHIFT, 0, movetoworkspace, 10

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
