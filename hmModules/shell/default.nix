{
  lib,
  pkgs,
  age,
  hostname,
  ...
}:
{
  programs.bat.enable = true;

  programs.ranger = {
    enable = true;
    settings = {
      "preview_images" = true;
      "preview_images_method" = "sixel";
    };
  };

  programs.fzf.enable = true;

  programs.ripgrep.enable = true;

  programs.fd.enable = true;

  programs.zellij =
    let
      zjstatus = pkgs.fetchurl {
        url = "https://github.com/dj95/zjstatus/releases/download/v0.17.0/zjstatus.wasm";
        hash = "sha256-IgTfSl24Eap+0zhfiwTvmdVy/dryPxfEF7LhVNVXe+U=";
      };
      layout = pkgs.writeText "layout.kdl" ''
            layout {
              default_tab_template {
                pane size=1 borderless=true {
                    plugin location="file:${zjstatus}" {
                      // Nord theme                          
                      color_fg "#cdd6f4" 
                      color_bg "#1e1e2e"
                      color_black "#45475a"
                      color_red "#f38ba8"
                      color_green "#a6e3a1"
                      color_yellow "#f9e2af"
                      color_blue "#89b4fa"
                      color_magenta "#f5c2e7"
                      color_cyan "#94e2d5"
                      color_white "#bac2de"
                      
                      format_left   "{mode}#[bg=$bg] {tabs}"
                      format_center "#[bg=$bg,fg=$fg] Zellij: #[bg=$bg,fg=$fg]{session}"
                      format_right  "{datetime}"
                      format_space  "#[bg=$bg]"
                      format_hide_on_overlength "true"
                      format_precedence "crl"

                      border_enabled  "false"
                      border_char     "─"
                      border_format   "#[fg=#6C7086]{char}"
                      border_position "top"

                      hide_frame_for_single_pane "true"

                      mode_normal        "#[bg=$green,fg=$bg,bold] NORMAL #[bg=$bg,fg=$green]"
                      mode_locked        "#[bg=$red,fg=$bg,bold] LOCKED  #[bg=$bg,fg=$red]"
                      mode_resize        "#[bg=$blue,fg=$bg,bold] RESIZE #[bg=$bg,fg=$blue]"
                      mode_pane          "#[bg=$blue,fg=$bg,bold] PANE #[bg=$bg,fg=$blue]"
                      mode_tab           "#[bg=$yellow,fg=$bg,bold] TAB #[bg=$bg,fg=$yellow]"
                      mode_scroll        "#[bg=$blue,fg=$bg,bold] SCROLL #[bg=$bg,fg=$blue]"
                      mode_enter_search  "#[bg=$yellow,fg=$bg,bold] ENT-SEARCH #[bg=$bg,fg=$yellow]"
                      mode_search        "#[bg=$yellow,fg=$bg,bold] SEARCHARCH #[bg=$bg,fg=$yellow]"
                      mode_rename_tab    "#[bg=$yellow,fg=$bg,bold] RENAME-TAB #[bg=$bg,fg=$yellow]"
                      mode_rename_pane   "#[bg=$blue,fg=$bg,bold] RENAME-PANE #[bg=$bg,fg=$blue]"
                      mode_session       "#[bg=$blue,fg=$bg,bold] SESSION #[bg=$bg,fg=$blue]"
                      mode_move          "#[bg=$blue,fg=$bg,bold] MOVE #[bg=$bg,fg=$blue]"
                      mode_prompt        "#[bg=$blue,fg=$bg,bold] PROMPT #[bg=$bg,fg=$blue]"
                      mode_tmux          "#[bg=$magenta,fg=$bg,bold] TMUX #[bg=$bg,fg=$magenta]"

                      // formatting for inactive tabs
                      tab_normal              "#[bg=$bg,fg=$cyan]#[bg=$cyan,fg=$bg,bold]{index} #[bg=$bg,fg=$cyan,bold] {name}{floating_indicator}#[bg=$bg,fg=$bg,bold]"
                      tab_normal_fullscreen   "#[bg=$bg,fg=$cyan]#[bg=$cyan,fg=$bg,bold]{index} #[bg=$bg,fg=$cyan,bold] {name}{fullscreen_indicator}#[bg=$bg,fg=$bg,bold]"
                      tab_normal_sync         "#[bg=$bg,fg=$cyan]#[bg=$cyan,fg=$bg,bold]{index} #[bg=$bg,fg=$cyan,bold] {name}{sync_indicator}#[bg=$bg,fg=$bg,bold]"

                      // formatting for the current active tab
                      tab_active              "#[bg=$bg,fg=$yellow]#[bg=$yellow,fg=$bg,bold]{index} #[bg=$bg,fg=$yellow,bold] {name}{floating_indicator}#[bg=$bg,fg=$bg,bold]"
                      tab_active_fullscreen   "#[bg=$bg,fg=$yellow]#[bg=$yellow,fg=$bg,bold]{index} #[bg=$bg,fg=$yellow,bold] {name}{fullscreen_indicator}#[bg=$bg,fg=$bg,bold]"
                      tab_active_sync         "#[bg=$bg,fg=$yellow]#[bg=$yellow,fg=$bg,bold]{index} #[bg=$bg,fg=$yellow,bold] {name}{sync_indicator}#[bg=$bg,fg=$bg,bold]"

                      // separator between the tabs
                      tab_separator           "#[bg=$bg] "

                      // indicators
                      tab_sync_indicator       " "
                      tab_fullscreen_indicator " 󰊓"
                      tab_floating_indicator   " 󰹙"

                      datetime        "#[fg=$fg] {format} "
                      datetime_format "%Y-%m-%d %H:%M"
                      datetime_timezone "Europe/Rome"
                    }
                }
                children
            }
        }
      '';
    in
    {
      enable = true;
      enableFishIntegration = true;
      settings = {
        default_layout = "${layout}";
        pane_frames = false;
      };
    };

  programs.direnv = {
    enable = true;
    config = {
      warn_timeout = "60s"; # default was 5s
    };
    nix-direnv.enable = true;
  };

  programs.lsd = {
    enable = true;
    enableAliases = true;
  };

  programs.vim.enable = true;

  programs.ssh = {
    enable = true;
    controlMaster = "auto";
  };

  systemd.user.services.atuind = {
    Unit.Description = "Atuin daemon";
    Install = {
      WantedBy = [ "default.target" ];
    };
    Service.ExecStart = "${lib.getExe pkgs.atuin} daemon";
  };

  programs.atuin = {
    enable = true;
    settings = {
      daemon.enabled = true;
      auto_sync = true;
      sync_frequency = "5m";
      sync_address = "http://sisko.fleet:8889";
      search_mode = "fuzzy";
      style = "compact";
    };
  };

  programs.fish = {
    enable = true;
    plugins = [
      {
        name = "fifc";
        src = pkgs.fishPlugins.fifc.src;
      }
      {
        name = "z";
        src = pkgs.fishPlugins.fifc.src;
      }
    ];
    shellInit =
      ''
        fish_vi_key_bindings
      ''
      + lib.optionalString (builtins.hasAttr "cachix-personal-token" age.secrets) ''
        export CACHIX_AUTH_TOKEN=$(cat ${age.secrets.cachix-personal-token.path})
      '';
    shellAliases = {
      "cat" = "bat";
    };
  };

  home.packages =
    with pkgs;
    [
      thefuck
      dig.dnsutils
      lsof
      comma
      ffmpeg-headless
      jless
      nix-melt
      nurl
      jq
      yq-go
      procs
      chafa
      hexyl
      broot
      file
    ]
    ++ (lib.optionals
      (builtins.elem hostname [
        "kirk"
        "picard"
      ])
      [
        cntr # TODO probably not best place
      ]
    );
}
