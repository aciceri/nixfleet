{ pkgs, ... }:
{
  fonts = {
    packages =
      with pkgs;
      [
        powerline-fonts
        dejavu_fonts
        fira-code
        fira-code-symbols
        iosevka
        iosevka-comfy.comfy
        emacs-all-the-icons-fonts
        joypixels
        etBook
        vegur
      ]
      ++ (builtins.filter lib.attrsets.isDerivation (builtins.attrValues nerd-fonts));
    fontconfig.defaultFonts = {
      monospace = [ "DejaVu Sans Mono for Powerline" ];
      sansSerif = [ "DejaVu Sans" ];
      serif = [ "DejaVu Serif" ];
    };
  };
  nixpkgs.config.joypixels.acceptLicense = true;
}
