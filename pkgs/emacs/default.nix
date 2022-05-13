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
      aggressive-indent
      all-the-icons
      company
      company-nixos-options
      dap-mode
      diff-hl
      envrc
      doom-modeline
      evil
      evil-collection
      fira-code-mode
      go-translate
      good-scroll
      haskell-mode
      helm
      helm-ag
      helm-company
      helm-nixos-options
      helm-projectile
      lispy
      lsp-haskell
      lsp-mode
      lsp-python-ms
      lsp-ui
      magit
      magit-delta
      nix-mode
      nix-modeline
      nixos-options
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
      symex
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
