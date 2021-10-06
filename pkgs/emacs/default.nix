{ pkgs, ... }:
let
  myEmacs = pkgs.emacsPgtkGcc;
  emacsWithPackages = (pkgs.emacsPackagesFor myEmacs).emacsWithPackages;
in
emacsWithPackages (
  epkgs: (
    with epkgs.melpaStablePackages; []
  ) ++ (
    with epkgs.melpaPackages; [
      all-the-icons
      use-package
      evil
      evil-collection
      helm
      projectile
      magit
      fira-code-mode
      org-superstar
      nix-mode
      lispy
      lsp-mode
      dap-mode
      which-key
      sudo-utils
      treemacs
      treemacs-evil
      treemacs-projectile
      treemacs-icons-dired
      treemacs-magit
      treemacs-persp
    ]
  ) ++ (
    with epkgs.elpaPackages; [
      modus-themes
    ]
  ) ++ []
)
