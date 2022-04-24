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
      # dirvish
      all-the-icons
      company
      dap-mode
      diff-hl
      doom-modeline
      evil
      evil-collection
      fira-code-mode
      good-scroll
      haskell-mode
      helm
      helm-ag
      helm-company
      helm-projectile
      lispy
      lsp-haskell
      lsp-mode
      lsp-python-ms
      magit
      nix-mode
      notmuch
      org-download
      org-fragtog
      org-roam
      org-roam-ui
      org-superstar
      projectile
      psc-ide
      psci
      purescript-mode
      rainbow-delimiters
      rainbow-identifiers
      scad-mode
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
