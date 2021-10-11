{ pkgs, ... }:
{
  home.file."emacs" = {
    recursive = true;
    source = ./emacs.d;
    target = ".emacs.d";
  };

  programs.emacs = {
    enable = true;
    package = pkgs.customEmacs;
  };

  home.packages = with pkgs; [
    python-language-server
    fd
    ag
    nixpkgs-fmt
    rnix-lsp
  ];
}
