{ pkgs, ... }:
{
  home.packages = with pkgs; [ wl-clipboard ];
  wayland = {
    windowManager.sway =
      let
        modifier = "Mod4";
      in
        {
          enable = true;
          wrapperFeatures.gtk = true;
          config = {
            modifier = modifier;
            menu = "${pkgs.bemenu}/bin/bemenu-run -b -m 1 -p 'λ'";
            output = {
              HDMI-A-2 = {
                #bg = "~/dotfiles/dotfiles/xorg/wallpaper.jpg fill";
              };
            };
            #fonts = [ "Font Awesome" "Fira Code" ];
            terminal = "${pkgs.foot}/bin/footclient";
            bars = [
              {
                command = "${pkgs.waybar}/bin/waybar";
              }
            ];

            startup = let
              gsettings = "${pkgs.glib}/bin/gsettings";
              gsettingsscript = pkgs.writeShellScript "gsettings-auto.sh" ''
                expression=""
                for pair in "$@"; do
                  IFS=:; set -- $pair
                  expressions="$expressions -e 's:^$2=(.*)$:${gsettings} set org.gnome.desktop.interface $1 \1:e'"
                done
                IFS=
                echo "" >/tmp/gsettings.log
                echo exec sed -E $expressions "''${XDG_CONFIG_HOME:-$HOME/.config}"/gtk-3.0/settings.ini &>>/tmp/gsettings.log
                eval exec sed -E $expressions "''${XDG_CONFIG_HOME:-$HOME/.config}"/gtk-3.0/settings.ini &>>/tmp/gsettings.log
              '';
              gsettingscmd = ''${gsettingsscript} \
    gtk-theme:gtk-theme-name \
    icon-theme:gtk-icon-theme-name \
    font-name:gtk-font-name \
    cursor-theme:gtk-cursor-theme-name'';
            in
              [
                {
                  command = "foot --server";
                  always = true;
                }

                #{ always = true; command = "${gsettingscmd}"; }
              ];
            window.commands = [
              { criteria = { app_id = "mpv"; }; command = "sticky enable"; }
              { criteria = { app_id = "mpv"; }; command = "floating enable"; }
              { criteria = { title = "MetaMask Notification.*"; }; command = "floating enable"; }
            ];
            input = {
              "*" = {
                xkb_layout = "us";
                xkb_variant = "intl";
              };
            };
          };
          extraConfig = ''
            bindsym ${modifier}+p move workspace to output right
            #seat seat0 xcursor_theme "Adwaita"
          '';
          xwayland = true;
          systemdIntegration = true;
        };
  };

  programs.waybar = {
    enable = true;
    style = builtins.readFile ./style.css;
    settings = [
      {
        layer = "top";
        position = "top";
        #output = [ "HDMI-A-2" ];

        modules-left = [
          "sway/mode"
          "sway/workspaces"
        ];
        modules-center = [];
        modules-right = [
          "idle_inhibitor"
          "tray"
          "network"
          "cpu"
          "memory"
          "pulseaudio"
          "clock"
          "backlight"
          "battery"
        ];

        modules = {
          "sway/workspaces" = {
            all-outputs = true;
            disable-scroll-wraparound = true;
          };

          "sway/mode" = { tooltip = false; };

          idle_inhibitor = {
            format = "{icon}";
            format-icons = {
              activated = "unlocked";
              deactivated = "locking";
            };
          };

          pulseaudio = {
            format = "vol {volume}%";
            on-click-middle = "${pkgs.sway}/bin/swaymsg exec \"${pkgs.pavucontrol}/bin/pavucontrol\"";
          };

          network = {
            format-wifi = "{essid} {signalStrength}% {bandwidthUpBits} {bandwidthDownBits}";
            format-ethernet = "{ifname} eth {bandwidthUpBits} {bandwidthDownBits}";
          };

          cpu = {
            interval = 2;
            format = "cpu {load}% {usage}%";
          };

          memory.format = "mem {}%";

          backlight = {
            format = "nit {percent}%";
            on-scroll-up = "${pkgs.light}/bin/light -A 2";
            on-scroll-down = "${pkgs.light}/bin/light -U 2";
          };

          tray.spacing = 10;

          clock.format = "{:%a %b %d %H:%M}";

          battery = {
            format = "bat {}";
          };
        };

      }
    ];
  };
}
