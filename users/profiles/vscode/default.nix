{ pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    package = pkgs.vscode-fhs;

  #   userSettings = {
  #     "update.channel" = "none";
  #     "editor" = {
  #       "formatOnSave" = true;
  #       "fontFamily" = "Fira Code";
  #       "fontLigatures" = true;
  #     };
  #     "window"."menuBarVisibility" = "classic";
  #     "[nix]"."editor.tabSize" = 2;
  #     "nix"."enableLanguageServer" = true;
  #     "github.copilot.enable" = {
  #       "*" = true;
  #     };
  #   };
  #   # extensions = with pkgs.vscode-extensions; [
  #   #   eamodio.gitlens
  #   #   jnoortheen.nix-ide
  #   #   haskell.haskell
  #   #   justusadam.language-haskell
  #   #   #ms-python.python
  #   # ];
  # };

#   home.packages = with pkgs; [
#     gnome.gnome-keyring
#     stylish-haskell
#     ghc
#   ] ++ (if pkgs.system == "x86_64-linux" then [
#     haskell-language-server
#   ] else [ ]);
  };
}
