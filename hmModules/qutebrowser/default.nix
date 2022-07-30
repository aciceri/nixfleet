{pkgs, ...}: {
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
      url.start_pages = ["https://searx.be"];
      editor.command = [
        "emacsclient"
        "+{line}:{column}"
        "{file}"
        "-c"
      ];
      content.pdfjs = true;
      tabs.tabs_are_windows = true;
    };
  };
  home.packages = [
    (
      pkgs.makeDesktopItem {
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
