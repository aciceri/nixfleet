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
    ../foot
  ];
  config = {
    home.packages = with pkgs; [wl-clipboard];

    services.network-manager-applet.enable = true;
    services.blueman-applet.enable = true;
    services.pasystray.enable = true;
    xsession.enable = true;

    services.udiskie.enable = true;

    gtk = {
      enable = true;
      font.name = "Fira Code,Symbols Nerd Font";
      iconTheme = {
        name = "Adwaita";
        package = pkgs.gnome.adwaita-icon-theme;
      };
    };

    # TODO check if work (just wait?)
    services.swayidle.enable = true;

    wayland = {
      windowManager.sway = let
        modifier = "Mod4";
      in {
        enable = true;
        wrapperFeatures.gtk = true;
        config = {
          modifier = modifier;
          menu = "${pkgs.fuzzel}/bin/fuzzel --background-color=253559cc --border-radius=5 --border-width=0";
          output = let
            bg = "${./wallpaper.png} fill";
          in {
            DP-1 = {
              pos = "0 0";
              inherit bg;
            };
            eDP-1 = {
              inherit bg;
            };
          };
          #fonts = [ "Font Awesome" "Fira Code" ];
          terminal = "footclient";
          bars = [
            {
              command = "${pkgs.waybar}/bin/waybar";
            }
          ];
          floating.criteria = [
            {title = "MetaMask Notification.*";}
            {title = "Volume Control";} # pavucontrol
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
              ${pkgs.grim}/bin/grim -t png -g "$coords" $filename
              wl-copy -t image/png < $filename
            '';
          in
            lib.mkOptionDefault {
              "${modifier}+x" = "exec emacsclient -c";
              "${modifier}+b" = "exec qutebrowser";
              "${modifier}+s" = "exec ${screenshotScript}";
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
