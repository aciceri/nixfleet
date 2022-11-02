{
  pkgs,
  config,
  ...
}: {
  programs.qutebrowser = {
    enable = true;
    searchEngines = {
      DEFAULT = "https://searx.be/search?q={}&category_general=on&language=all";
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
        "<z><l>" = "spawn --userscript qute-pass --dmenu-invocation 'fuzzel -d'";
        "<z><u><l>" = "spawn --userscript qute-pass --dmenu-invocation 'fuzzel -d' --username-only";
        "<z><p><l>" = "spawn --userscript qute-pass --dmenu-invocation 'fuzzel -d' --password-only";
        "<z><o><l>" = "spawn --userscript qute-pass --dmenu-invocation 'fuzzel -d' --otp-only";
      };
    };
    settings = {
      auto_save.session = true;
      url.start_pages = ["https://searx.be"];
      editor.command = [
        "emacsclient"
        "+{line}:{column}"
        "{file}"
        "-c"
      ];
      content.pdfjs = true;
      scrolling.smooth = true;
      fonts = {
        default_size = "11pt";
        tabs = {
          selected = "13pt";
          unselected = "13pt";
        };
      };
      colors = {
        tabs = {
          even = {
            bg = "silver";
            fg = "#666666";
          };
          odd = {
            bg = "gainsboro";
            fg = config.programs.qutebrowser.settings.colors.tabs.even.fg;
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
    (
      makeDesktopItem {
        name = "qutebrowser";
        exec = "qutebrowser %u";
        comment = "Qutebrowser";
        desktopName = "qutebrowser";
        type = "Application";
        mimeTypes = ["x-scheme-handler/https"];
      }
    )
  ];
}
