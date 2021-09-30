{
  programs.foot = {
    enable = true;
    server.enable = false; # server is executed by sway without systemd integration
    settings = {
      main = {
        term = "xterm-256color";

        font = "Fira Code:size=11";
        dpi-aware = "yes";
      };

      mouse = {
        hide-when-typing = "yes";
      };
    };

  };
}
