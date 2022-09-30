{
  pkgs,
  config,
  ...
}: {
  programs.emacs.enable = true;

  programs.doom-emacs = {
    enable = true;
    package = pkgs.emacs28NativeComp;
    doomPrivateDir = ../../doom.d;
  };

  services.emacs = {
    enable = true;
    defaultEditor = true;
  };

  home.packages = with pkgs; [
    binutils
    (ripgrep.override {withPCRE2 = true;})
    gnutls
    fd
    imagemagick
    sqlite
    maim
    xclip
  ];
}
