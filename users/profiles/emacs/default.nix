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
    fd
    ag
    nixpkgs-fmt
    rnix-lsp
  ] ++ (if config.network.hostname != "mbp" then python-language-server else [ ]);
}
