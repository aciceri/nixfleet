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
    python
    fd
    ag
    nixpkgs-fmt
    rnix-lsp
    (
      makeDesktopItem {
        name = "org-protocol";
        exec = "emacs %u";
        #exec = "emacsclient %u";
        comment = "Org protocol";
        desktopName = "org-protocol";
        type = "Application";
        mimeType = "x-scheme-handler/org-protocol";
      }
    )
  ] ++ (if pkgs.system == "x86_64-linux" then [ python-language-server ] else [ ]);
}
