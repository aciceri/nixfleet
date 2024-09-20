{ pkgs, ... }:
{
  programs.btop = {
    enable = true;
    settings = {
      update_ms = 100;
      theme_background = false;
      # color_theme = "${config.programs.btop.package}/share/btop/themes/dracula.theme";
      color_theme =
        let
          catppuccin-theme = pkgs.fetchFromGitHub {
            owner = "catppuccin";
            repo = "btop";
            rev = "21b8d5956a8b07fa52519e3267fb3a2d2e693d17";
            hash = "sha256-UXeTypc15MhjgGUiCrDUZ40m32yH2o1N+rcrEgY6sME=";
          };
        in
        "${catppuccin-theme}/themes/catppuccin_mocha.theme";
    };
  };
}
