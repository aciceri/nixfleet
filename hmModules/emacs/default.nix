{pkgs, ...}: {
  programs.emacs.enable = true;
  programs.doom-emacs = {
    enable = true;
    package = pkgs.emacs28NativeComp;
    doomPrivateDir = ../../doom.d;
  };

  services.emacs = {
    enable = true;
  };
}
