{
  pkgs,
  config,
  ...
}:
let
  inherit (config.programs.qutebrowser) settings;
  websites = {
    searx = "https://searx.be";
  };
  colors = {
    black = "#000000";
    darker-gray = "#222222";
    lighter-gray = "#333333";
    white = "#ffffff";
    dark-white = "#aaaaaa";
    less-dark-white = "#cccccc";
    blue = "#0000ff";
  };
in
{
  programs.qutebrowser = {
    enable = true;
    searchEngines = with websites; {
      DEFAULT = "${searx}/search?q={}&category_general=on&language=all";
      w = "https://en.wikipedia.org/wiki/Special:Search?search={}&go=Go&ns0=1";
      np = "https://search.nixos.org/packages?sort=relevance&type=packages&query={}";
      no = "https://search.nixos.org/options?sort=relevance&type=options&query={}";
      g = "https://google.com/search?q={}";
      git = "https://github.com/search?q={}";
      y = "https://www.youtube.com/results?search_query={}";
    };
    keyBindings = {
      normal = {
        "<Ctrl-V>" = "spawn mpv --force-window=immediate {url}";
        ",l" = ''config-cycle spellcheck.languages [" it-IT "] [" en-US "]'';
      };
      insert = {
        "<Ctrl-p>" = ''spawn --userscript qute-pass --dmenu-invocation '${pkgs.fuzzel}/bin/fuzzel --background-color=253559cc --border-radius=5 --border-width=0 -d' --password-only --unfiltered'';
      };
    };
    settings = {
      auto_save.session = true;
      url = with websites; {
        default_page = searx;
        start_pages = [ searx ];
      };
      editor.command = [
        "emacsclient"
        "+{line}:{column}"
        "{file}"
        "-c"
        "-F"
        "'(name . \\\"{file} - editor - qutebrowser\\\"))" # this is needed to keep the Emacs frame in the correct Sway workspace
      ];
      content.pdfjs = true;
      scrolling.smooth = false;
      fonts = {
        default_size = "11pt";
        tabs = {
          selected = "13pt";
          unselected = "13pt";
        };
      };
      colors = with colors; {
        webpage.bg = black; # to avoid flashes when opening new tabs
        tabs = {
          even = {
            bg = darker-gray;
            fg = dark-white;
          };
          odd = {
            bg = lighter-gray;
            inherit (settings.colors.tabs.even) fg;
          };
        };
        completion = {
          even.bg = darker-gray;
          odd.bg = settings.colors.completion.even.bg;
          fg = less-dark-white;
          # match.fg = "";
          item.selected = {
            match.fg = blue;
            # bg = "";
            # fg = "";
            border = {
              top = settings.colors.completion.even.bg;
              bottom = settings.colors.completion.even.bg;
            };
          };
          category = {
            bg = lighter-gray;
            border = {
              top = settings.colors.completion.even.bg;
              bottom = settings.colors.completion.even.bg;
            };
          };
        };
      };
    };
    # `c.tabs.padding` must be set here since it's a python dict
    extraConfig = ''
      c.tabs.padding = {
        'bottom': 4,
        'left': 4,
        'right': 4,
        'top': 4
      }
    '';
  };
  home.packages = with pkgs; [
    fuzzel
    (makeDesktopItem {
      name = "qutebrowser";
      exec = "qutebrowser %u";
      comment = "Qutebrowser";
      desktopName = "qutebrowser";
      type = "Application";
      mimeTypes = [ "x-scheme-handler/https" ];
    })
  ];
}
