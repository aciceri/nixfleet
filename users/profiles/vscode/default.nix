{ pkgs, ... }:
{
  # only purpose of this is to make vscode login to Github
  services.gnome-keyring = {
    enable = true;
  };

  programs.vscode = {
    enable = true;

    userSettings = {
      "update.channel" = "none";
      "editor" = {
        "formatOnSave" = true;
        "fontFamily" = "Fira Code";
        "fontLigatures" = true;
      };
      "window"."menuBarVisibility" = "classic";
      "[nix]"."editor.tabSize" = 2;
      "nix"."enableLanguageServer" = true;
    };
    extensions = with pkgs.vscode-extensions; [
      eamodio.gitlens
      jnoortheen.nix-ide
      haskell.haskell
      justusadam.language-haskell
      #ms-python.python
    ];
  };

  home.packages = with pkgs; [
    haskell-language-server
    stylish-haskell
    ghc
  ];
}
