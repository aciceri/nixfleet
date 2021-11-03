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
    if pkgs.stdenv.hostPlatform.isDarwin then {
      DICPATH = "${pkgs.hunspellDicts.it_IT}/share/hunspell:${pkgs.hunspellDicts.en_US}/share/hunspell";
    } else { };

  home.packages =
    let
      easy-ps = import
        (pkgs.fetchFromGitHub {
          owner = "justinwoo";
          repo = "easy-purescript-nix";
          rev = "7802db65618c2ead3a55121355816b4c41d276d9";
          sha256 = "0n99hxxcp9yc8yvx7bx4ac6askinfark7dnps3hzz5v9skrvq15q";
        })
        {
          inherit pkgs;
        };
    in
    with pkgs; [
      python3Full
      fd
      ag
      nixpkgs-fmt
      rnix-lsp
      haskell-language-server
      stylish-haskell
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
    ] ++ (if pkgs.system == "x86_64-linux" then [
      python-language-server
    ] ++ (with easy-ps; [
      purs
      spago
      spago2nix
      pulp
      purescript-language-server
      purs-tidy
      nodejs
    ]) else [ ]);
}
