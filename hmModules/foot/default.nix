{
  lib,
  pkgs,
  ...
}: {
  programs.foot = let
    catppuccin = pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "foot";
      rev = "307611230661b7b1787feb7f9d122e851bae97e9";
      hash = "sha256-mkPYHDJtfdfDnqLr1YOjaBpn4lCceok36LrnkUkNIE4=";
    };
  in {
    enable = true;
    server.enable = true;
    settings = {
      main = {
        term = "xterm-256color";
        login-shell = "yes";
        # Using dpi-aware = "yes" font size is too small on my external monitor
        # Scaling that output in sway is inefficient and make XWayland apps blurred
        dpi-aware = "no";
        horizontal-letter-offset = "1";
        include = "${catppuccin}/themes/catppuccin-mocha.ini";
        font = let
          size = "13";
        in
          lib.concatStringsSep ", " [
            "Iosevka Comfy:size=${size}"
            "Symbols Nerd Font:size=${size}"
            "JoyPixels:size=${size}"
          ];
      };

      mouse = {
        hide-when-typing = "yes";
      };
    };
  };
}
