{ pkgs, lib, ... }:
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
          output =
            let
              bg = "${./wallpaper.jpg} fill"; in
            {
              HDMI-A-2 = {
                inherit bg;
              };
              eDP-1 = {
                inherit bg;
              };
            };
          #fonts = [ "Font Awesome" "Fira Code" ];
          terminal = "${pkgs.foot}/bin/footclient";
          bars = [
            {
              command = "${pkgs.waybar}/bin/waybar";
            }
          ];

          startup = [
            {
              command = "foot --server";
              always = true;
            }
          ];
          floating.criteria = [
            { title = "MetaMask Notification.*"; }
            { title = "Volume Control"; } # pavucontrol
          ];
          input = {
            "*" = {
              xkb_layout = "us";
              xkb_variant = "intl";
            };
          };
          keybindings =
            let
              screenshotScript = pkgs.writeShellScript "screenshot.sh" ''
                filename="$HOME/shots/$(date --iso-8601=seconds).png"
                coords="$(${pkgs.slurp}/bin/slurp)"
                ${pkgs.grim}/bin/grim -t png -g "$coords" $filename
                wl-copy -t image/png < $filename
              '';
            in
            lib.mkOptionDefault {
              "${modifier}+x" = "exec ${pkgs.customEmacs}/bin/emacs";
              "${modifier}+b" = "exec ${pkgs.firefox}/bin/firefox";
              "${modifier}+s" = "exec ${screenshotScript}";
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
        height = 30;

        modules-left = [
          "sway/mode"
          "sway/workspaces"
        ];
        modules-center = [ "sway/window" ];
        modules-right = [
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

          "sway/window" = { max_length = 50; };

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
