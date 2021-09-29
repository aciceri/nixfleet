{ pkgs, ... }:
{
  home.file."emacs" = {
    recursive = true;
    source = ./emacs.d;
    target = ".emacs.d";
  };

  programs.emacs = {
    enable = true;
    package =
      let
        myEmacs = pkgs.emacsPgtkGcc;
        emacsWithPackages = (pkgs.emacsPackagesFor myEmacs).emacsWithPackages;
      in
      emacsWithPackages (
        epkgs: (
          with epkgs.melpaStablePackages; [ ]
        ) ++ (
          with epkgs.melpaPackages; [
            all-the-icons
            use-package
            evil
            evil-collection
            projectile
            magit
            fira-code-mode
            nix-mode
            lispy
            lsp-mode
            dap-mode
            which-key
          ]
        ) ++ (
          with epkgs.elpaPackages; [
            modus-themes
          ]
        ) ++ [ ]
      );
  };
}
