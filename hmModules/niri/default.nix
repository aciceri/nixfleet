{
  pkgs,
  lib,
  config,
  hostname,
  ...
}:
let
  niriVars =
    {
      picard = {
        floating-gptel = {
          rows = "60";
          cols = "150";
        };
        floating-btop = {
          rows = "60";
          cols = "210";
        };
      };
      kirk = {
        floating-gptel = {
          rows = "40";
          cols = "140";
        };
        floating-btop = {
          rows = "40";
          cols = "140";
        };
      };
    }
    ."${hostname}" or {
      floating-gptel = {
        rows = "40";
        cols = "140";
      };
      floating-btop = {
        rows = "40";
        cols = "140";
      };
    };
  run-floating-gptel =
    with niriVars.floating-gptel;
    pkgs.writeScriptBin "run-floating-gptel" ''
      emacsclient -c --eval '(switch-to-buffer (gptel "*GptEl*"))' -F '((name . "GPTel - Emacs") (width . ${cols}) (height . ${rows}))'
    '';
  run-floating-btop =
    with niriVars.floating-btop;
    pkgs.writeScriptBin "run-floating-btop" ''
      foot --title='bTop' -W ${cols}x${rows} btop
    '';
in
{
  home.packages = with pkgs; [
    niri
    waypaper
    xwayland-satellite
    run-floating-gptel
    run-floating-btop
  ];
  systemd.user.targets.niri-session = {
    Unit = {
      Description = "Niri session";
      BindsTo = [ "graphical-session.target" ];
      Wants = [
        "graphical-session-pre.target"
        "xdg-desktop-autostart.target"
      ];
      After = [ "graphical-session-pre.target" ];
      Before = [ "xdg-desktop-autostart.target" ];
    };
  };

  home.file."${config.xdg.configHome}/niri/wallpaper.png" = {
    source = ../hyprland/wallpaper.png;
  };

  home.activation.linkNiriConfig = lib.hm.dag.entryAnywhere ''
    if [ ! -e "$HOME/.config/niri/config.kdl" ]; then
      $DRY_RUN_CMD ln -s "$HOME/projects/aciceri/nixfleet/hmModules/niri/config.kdl" "$HOME/.config/niri/config.kdl"
    fi
  '';

  home.sessionVariables = {
    DISPLAY = ":0";
    QT_QPA_PLATFORM = "wayland";
  };

  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    theme =
      let
        inherit (config.lib.formats.rasi) mkLiteral;
        cfg = config.catppuccin.fzf;
        palette = (lib.importJSON "${config.catppuccin.sources.palette}/palette.json").${cfg.flavor}.colors;
        selectColor = color: palette.${color}.hex;

      in
      lib.mkForce {
        "*" = {
          # blue = mkLiteral "#0000FF";
          # white = mkLiteral "#FFFFFF";
          # black = mkLiteral "#000000";
          # grey = mkLiteral "#eeeeee";

          blue = mkLiteral (selectColor "blue");
          white = mkLiteral "#FFFFFF";
          black = mkLiteral "#000000";
          grey = mkLiteral "#eeeeee";

          spacing = 2;
          background-color = mkLiteral "#00000000";
          border-color = mkLiteral "#444444FF";
          anchor = mkLiteral "north";
          location = mkLiteral "center";
        };

        "window" = {
          transparency = "real";
          background-color = mkLiteral "#00000000";
          border = 0;
          padding = mkLiteral "0% 0% 1em 0%";
          x-offset = 0;
          y-offset = mkLiteral "-10%";
        };

        "mainbox" = {
          padding = mkLiteral "0px";
          border = 0;
          spacing = mkLiteral "1%";
        };

        "message" = {
          border = 0;
          border-radius = mkLiteral "4px";
          padding = mkLiteral "1em";
          background-color = mkLiteral "@white";
          text-color = mkLiteral "@black";
        };

        "textbox normal" = {
          text-color = mkLiteral "#002B36FF";
          padding = 0;
          border = 0;
        };

        "listview" = {
          fixed-height = 1;
          border = 0;
          padding = mkLiteral "1em";
          reverse = false;
          border-radius = mkLiteral "4px";

          columns = 1;
          background-color = mkLiteral "@white";
        };

        "element" = {
          border = 0;
          padding = mkLiteral "2px";
          highlight = mkLiteral "bold";
        };

        "element-text" = {
          background-color = mkLiteral "inherit";
          text-color = mkLiteral "inherit";
        };

        "element normal.normal" = {
          text-color = mkLiteral "#002B36FF";
          background-color = mkLiteral "#F5F5F500";
        };

        "element normal.urgent" = {
          text-color = mkLiteral "#D75F00FF";
          background-color = mkLiteral "#F5F5F5FF";
        };

        "element normal.active" = {
          text-color = mkLiteral "#005F87FF";
          background-color = mkLiteral "#F5F5F5FF";
        };

        "element selected.normal" = {
          text-color = mkLiteral "#F5F5F5FF";
          background-color = mkLiteral "#4271AEFF";
        };

        "element selected.urgent" = {
          text-color = mkLiteral "#F5F5F5FF";
          background-color = mkLiteral "#D75F00FF";
        };

        "element selected.active" = {
          text-color = mkLiteral "#F5F5F5FF";
          background-color = mkLiteral "#005F87FF";
        };

        "element alternate.normal" = {
          text-color = mkLiteral "#002B36FF";
          background-color = mkLiteral "#D0D0D0FF";
        };

        "element alternate.urgent" = {
          text-color = mkLiteral "#D75F00FF";
          background-color = mkLiteral "#D0D0D0FF";
        };

        "element alternate.active" = {
          text-color = mkLiteral "#005F87FF";
          background-color = mkLiteral "#D0D0D0FF";
        };

        "scrollbar" = {
          border = 0;
          padding = 0;
        };

        "inputbar" = {
          spacing = 0;
          border = 0;
          padding = mkLiteral "0.5em 1em";
          background-color = mkLiteral "@grey";
          index = 0;

          border-radius = mkLiteral "4px";

          children = map mkLiteral [
            "prompt"
            "textbox-prompt-colon"
            "entry"
            "case-indicator"
          ];
        };

        "inputbar normal" = {
          foreground-color = mkLiteral "#002B36FF";
          background-color = mkLiteral "#F5F5F500";
        };

        "mode-switcher" = {
          border = 0;
          padding = mkLiteral "0.5em 1em";
          background-color = mkLiteral "@grey";
          index = 10;
        };

        "button selected" = {
          text-color = mkLiteral "#4271AEFF";
        };

        "textbox-prompt-colon" = {
          expand = false;
          str = ":";
          margin = mkLiteral "0px 0.3em 0em 0em";
          text-color = mkLiteral "@black";
        };

        "error-message" = {
          border = 0;
          border-radius = mkLiteral "4px";
          padding = mkLiteral "1em";
          background-color = mkLiteral "#FF8888";
          text-color = mkLiteral "@black";
        };
      };
    extraConfig = {
      modi = "drun,window,ssh";
      combi-modes = [
        "drun"
        "window"
        "ssh"
      ];
    };
    font = "Iosevka Comfy 12";
    terminal = "footclient";
    pass = {
      enable = true;
      package = pkgs.rofi-pass-wayland;
    };
    plugins = [ pkgs.rofi-calc ];
  };
}
