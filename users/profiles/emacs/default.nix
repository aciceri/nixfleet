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

  services.emacs = {
    enable = true;
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
      delta
      fd
      graphviz-nox
      hunspell
      hunspellDicts.en_US
      hunspellDicts.it_IT
      imagemagick
      mediainfo
      nixpkgs-fmt
      poppler_utils
      python3Full
      rnix-lsp
      silver-searcher
      unzip
      (
        makeDesktopItem {
          name = "org-protocol";
          exec = "emacsclient %u";
          comment = "Org protocol";
          desktopName = "org-protocol";
          type = "Application";
          mimeTypes = [ "x-scheme-handler/org-protocol" ];
        }
      )
    ] ++ (if pkgs.system == "x86_64-linux" then [
      python-language-server
    ] ++ (with easy-ps; [
      ffmpegthumbnailer
    ]) else [ ]);
}
