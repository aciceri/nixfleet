{ pkgs, ... }:
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
      company
      dap-mode
      doom-modeline
      evil
      evil-collection
      fira-code-mode
      haskell-mode
      helm
      helm-ag
      helm-company
      helm-projectile
      lispy
      lsp-mode
      lsp-python-ms
      magit
      nix-mode
      org-download
      org-fragtog
      org-roam
      org-superstar
      projectile
      rainbow-delimiters
      sudo-utils
      treemacs
      treemacs-evil
      treemacs-icons-dired
      treemacs-magit
      treemacs-persp
      treemacs-projectile
      use-package
      visual-fill-column
      which-key
      writegood-mode
    ]
  ) ++ (
    with epkgs.elpaPackages; [
      modus-themes
      minimap
    ]
  ) ++ (
    with pkgs; [ ]
  )
)
