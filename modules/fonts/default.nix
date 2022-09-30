{pkgs, ...}: {
  fonts = {
    fonts = with pkgs; [powerline-fonts dejavu_fonts fira-code fira-code-symbols emacs-all-the-icons-fonts];
    fontconfig.defaultFonts = {
      monospace = ["DejaVu Sans Mono for Powerline"];
      sansSerif = ["DejaVu Sans"];
    };
  };
}
