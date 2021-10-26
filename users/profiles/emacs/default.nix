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

  # For some reason Hunspell dictionaries paths must be specified on Darwin
  home.sessionVariables =
    if pkgs.system == "x86_64-darwin" then {
      DICPATH = "${pkgs.hunspellDicts.it_IT}/share/hunspell:${pkgs.hunspellDicts.en_US}/share/hunspell";
    } else { };

  home.packages = with pkgs; [
    python3Full
    fd
    ag
    nixpkgs-fmt
    rnix-lsp
    graphviz-nox
    hunspell
    hunspellDicts.en_US
    hunspellDicts.it_IT
    (
      makeDesktopItem {
        name = "org-protocol";
        exec = "emacsclient %u";
        comment = "Org protocol";
        desktopName = "org-protocol";
        type = "Application";
        mimeType = "x-scheme-handler/org-protocol";
      }
    )
  ] ++ (if pkgs.system == "x86_64-linux" then [ python-language-server ] else [ ]);
}
