{
  programs.qutebrowser = {
    enable = true;
    keyBindings = {
      normal = {
        "<Ctrl-V>" = "spawn mpv {url}";
        ",l" = ''config-cycle spellcheck.languages [" it-IT "] [" en-US "]'';
        "<z><l>" = "spawn --userscript qute-pass --dmenu-invocation 'fuzzel -d'";
        "<z><u><l>" = "spawn --userscript qute-pass --dmenu-invocation 'fuzzel -d' --username-only";
        "<z><p><l>" = "spawn --userscript qute-pass --dmenu-invocation 'fuzzel -d' --password-only";
        "<z><o><l>" = "spawn --userscript qute-pass --dmenu-invocation 'fuzzel -d' --otp-only";
      };
    };
    settings = {
      editor.command = [
        "emacsclient"
        "+{line}:{column}"
        "{file}"
        "-c"
      ];
    };
  };
}
