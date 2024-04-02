{config, ...}: {
  programs.btop = {
    enable = true;
    settings = {
      update_ms = 100;
      theme_background = false;
      color_theme = "${config.programs.btop.package}/share/btop/themes/dracula.theme";
    };
  };
}
