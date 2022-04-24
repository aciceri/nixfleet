{
  programs.qutebrowser = {
    enable = true;
    keyBindings = {
      normal = {
        "<Ctrl-V>" = "spawn mpv {url}";
        ",l" = ''config-cycle spellcheck.languages ["it-IT"] ["en-US"]'';
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
