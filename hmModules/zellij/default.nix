{
  config,
  pkgs,
  lib,
  ...
}:
let
  zjstatus = pkgs.fetchurl {
    url = "https://github.com/dj95/zjstatus/releases/download/v0.17.0/zjstatus.wasm";
    hash = "sha256-IgTfSl24Eap+0zhfiwTvmdVy/dryPxfEF7LhVNVXe+U=";
  };
  cfg = config.catppuccin.fzf;
  palette = (lib.importJSON "${config.catppuccin.sources.palette}/palette.json").${cfg.flavor}.colors;
  selectColor = color: palette.${color}.hex;
  color_fg = selectColor "text";
  color_bg = selectColor "mantle";
  color_black = selectColor "surface1";
  color_red = selectColor "red";
  color_green = selectColor "green";
  color_yellow = selectColor "yellow";
  color_blue = selectColor "blue";
  color_magenta = selectColor "pink";
  color_cyan = selectColor "teal";
  color_white = selectColor "subtext1";
  layout = pkgs.writeText "layout.kdl" ''
    layout {
      default_tab_template {
        pane size=1 borderless=true {
            plugin location="file:${zjstatus}" {
              color_fg "${color_fg}" 
              color_bg "${color_bg}"
              color_black "${color_black}"
              color_red "${color_red}"
              color_green "${color_green}"
              color_yellow "${color_yellow}"
              color_blue "${color_blue}"
              color_magenta "${color_magenta}"
              color_cyan "${color_cyan}"
              color_white "${color_white}"

              format_left   "{mode}#[bg=$bg] {tabs}"
              // format_center "#[bg=$bg,fg=$fg] Zellij: #[bg=$bg,fg=$fg]{session}"
              // format_right  "{datetime}"
              format_right "#[bg=$bg,fg=$fg] Zellij: #[bg=$bg,fg=$fg]{session} "
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
              tab_normal              "#[bg=$bg,fg=$cyan] #[bg=$cyan,fg=$bg,bold] {index} {floating_indicator}#[bg=$bg,fg=$bg,bold]"
              tab_normal_fullscreen   "#[bg=$bg,fg=$cyan] #[bg=$cyan,fg=$bg,bold] {index} {fullscreen_indicator}#[bg=$bg,fg=$bg,bold]"
              tab_normal_sync         "#[bg=$bg,fg=$cyan] #[bg=$cyan,fg=$bg,bold] {index} {sync_indicator}#[bg=$bg,fg=$bg,bold]"

              // formatting for the current active tab
              tab_active              "#[bg=$bg,fg=$yellow] #[bg=$yellow,fg=$bg,bold] {index} {floating_indicator}#[bg=$bg,fg=$bg,bold]"
              tab_active_fullscreen   "#[bg=$bg,fg=$yellow] #[bg=$yellow,fg=$bg,bold] {index} {fullscreen_indicator}#[bg=$bg,fg=$bg,bold]"
              tab_active_sync         "#[bg=$bg,fg=$yellow] #[bg=$yellow,fg=$bg,bold] {index} {sync_indicator}#[bg=$bg,fg=$bg,bold]"

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
  programs.zellij = {
    enable = true;
    settings = {
      default_layout = "${layout}";
      pane_frames = false;
    };
  };
}
