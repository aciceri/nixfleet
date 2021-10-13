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
<<<<<<< HEAD
=======
    python-language-server
    python
>>>>>>> 651ab71 (Emacs and inputs updated)
    fd
    ag
    nixpkgs-fmt
    rnix-lsp
<<<<<<< HEAD
  ] ++ (if config.network.hostname != "mbp" then python-language-server else [ ]);
=======
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
  ];
>>>>>>> 651ab71 (Emacs and inputs updated)
}
