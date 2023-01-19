{lib, ...}: {
  programs.foot = {
    enable = true;
    server.enable = true;
    settings = {
      main = {
        term = "xterm-256color";
        login-shell = "yes";
        # Using dpi-aware = "yes" font size is too small on my external monitor
        # Scaling that output in sway is inefficient and make XWayland apps blurred
        dpi-aware = "no";
        font = let
          size = "12";
        in
          lib.concatStringsSep ", " [
            "Fira Code:size=${size}"
            "Symbols Nerd Font:size=${size}"
            "JoyPixels:size=${size}"
          ];
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
