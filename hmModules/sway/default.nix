{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./waybar.nix
    ./idle.nix
    ./mako.nix
    ./gammastep.nix
    # ../foot
    # ../alacritty
    ../kitty
  ];
  config = {
    home.packages = with pkgs; [wl-clipboard];

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

    services.swayidle.enable = true;

    wayland = {
      windowManager.sway = let
        modifier = "Mod4";
      in {
        enable = true;
        wrapperFeatures.gtk = true;
        config = {
          inherit modifier;
          menu = "${pkgs.fuzzel}/bin/fuzzel --background-color=253559cc --border-radius=5 --border-width=0";
          output = let
            bg = "${./wallpaper.svg} fill";
          in {
            DP-2 = {
              res = "1900x1200";
              pos = "0 0";
              inherit bg;
              transform = "90";
            };
            DP-1 = {
              res = "2560x1440";
              pos = "1200 230";
              inherit bg;
            };
            eDP-1 = {
              res = "1920x1080";
              pos = "3760 230";
              inherit bg;
            };
          };
          terminal = "footclient";
          bars = [
            {
              mode = "hide";
              position = "top";
              command = "${pkgs.waybar}/bin/waybar";
            }
          ];
          gaps = {
            smartBorders = "on";
          };
          assigns = {
            "1" = [{title = ".*Mozilla Firefox$";} {title = ".*qutebrowser$";}];
            "2" = [{title = "^((?!qutebrowser-editor).)*Emacs$";}];
            "3" = [{title = "Slack.*";}];
            "9" = [{title = "^Element.*";}];
          };
          floating.criteria = [
            {title = "MetaMask Notification.*";}
            {title = "Volume Control";} # pavucontrol
            {title = "^.*editor - qutebrowser$";} # Emacs opened by qutebrowser
          ];
          input = {
            "*" = {
              xkb_layout = "us";
              xkb_variant = "altgr-intl";
            };
          };
          keybindings = let
            screenshotScript = pkgs.writeShellScript "screenshot.sh" ''
              filename="$HOME/shots/$(date --iso-8601=seconds).png"
              coords="$(${pkgs.slurp}/bin/slurp)"
              ${pkgs.grim}/bin/grim -t png -g "$coords" "$filename"
              wl-copy -t image/png < $filename
            '';
            screenrecordingScript = pkgs.writeShellScript "screenrecorder.sh" ''
              filename="$HOME/shots/recording-$(date --iso-8601=seconds).mp4"
              coords="$(${pkgs.slurp}/bin/slurp)"
              ${pkgs.wf-recorder}/bin/wf-recorder -g "$coords" -f "$filename"
              wl-copy -t video/mp4 < $filename
            '';
          in
            lib.mkOptionDefault {
              "${modifier}+x" = "exec emacsclient -c";
              "${modifier}+y" = "exec ${pkgs.waypipe}/bin/waypipe --compress lz4=10 ssh mothership.fleet emacsclient -c";
              "${modifier}+b" = "exec qutebrowser";
              "${modifier}+s" = "exec ${screenshotScript}";
              # "${modifier}+g" = "exec ${screenrecordingScript}";  # FIXME
              "${modifier}+t" = ''
                exec emacsclient -c -F "\'(name . \\"VTerm\\"))" -q --eval '(vterm (getenv "SHELL"))'
              '';
              "${modifier}+u" = ''
                exec ${pkgs.waypipe}/bin/waypipe --compress lz4=10 ssh mothership.fleet emacsclient -c -F "\'(name . \\"VTerm\\"))" -q --eval '(eat (getenv "SHELL"))'
              '';
              "XF86MonBrightnessUp" = "exec ${pkgs.brightnessctl}/bin/brightnessctl s +5%";
              "XF86MonBrightnessDown" = "exec ${pkgs.brightnessctl}/bin/brightnessctl s 5%-";
            };
        };
        extraConfig = ''
          bindsym ${modifier}+p move workspace to output right
        '';
        xwayland = true;
        systemdIntegration = true;
      };
    };
  };
}
