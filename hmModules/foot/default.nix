{
  programs.foot = {
    enable = true;
    server.enable = true;
    settings = {
      main = {
        term = "xterm-256color";
        login-shell = "yes";
        font = "Fira Code,Symbols Nerd Font,JoyPixels";
      };

      mouse = {
        hide-when-typing = "yes";
      };

      colors = {
        background = "282C34";
      };
    };
  };
}
