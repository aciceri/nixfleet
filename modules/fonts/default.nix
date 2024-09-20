{ pkgs, ... }:
{
  fonts = {
    packages = with pkgs; [
      powerline-fonts
      dejavu_fonts
      fira-code
      fira-code-symbols
      iosevka
      iosevka-comfy.comfy
      emacs-all-the-icons-fonts
      nerdfonts
      joypixels
      etBook
      vegur
    ];
    fontconfig.defaultFonts = {
      monospace = [ "DejaVu Sans Mono for Powerline" ];
      sansSerif = [ "DejaVu Sans" ];
      serif = [ "DejaVu Serif" ];
    };
  };
  nixpkgs.config.joypixels.acceptLicense = true;
}
