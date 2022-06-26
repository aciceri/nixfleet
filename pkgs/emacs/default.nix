{ pkgs, ... }:
let
  # TODO: when `emcasPgtkNativeComp` will build on aarch64 re-use it
  myEmacs = with pkgs; if stdenv.hostPlatform.isAarch64 then emacs else emacsPgtkNativeComp;
  emacsWithPackages = (pkgs.emacsPackagesFor myEmacs).emacsWithPackages;
in
emacsWithPackages (
  epkgs: (
    with epkgs.melpaStablePackages; [ ]
  ) ++ (
    with epkgs.melpaPackages; [
      # ts-fold
      aggressive-indent
      all-the-icons
      company
      company-nixos-options
      dap-mode
      diff-hl
      diredfl
      dirvish
      doom-modeline
      envrc
      evil
      evil-collection
      evil-tree-edit
      fira-code-mode
      flycheck-status-emoji
      git-auto-commit-mode
      go-translate
      good-scroll
      haskell-mode
      helm
      helm-ag
      helm-company
      helm-nixos-options
      helm-projectile
      highlight-indent-guides
      hl-todo
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
      origami
      pkgs.emacs28Packages.tree-sitter-langs
      pkgs.emacs28Packages.tsc
      prettier
      projectile
      psc-ide
      psci
      purescript-mode
      rainbow-delimiters
      rainbow-identifiers
      scad-mode
      solidity-mode
      sudo-utils
      symex
      tide
      tree-edit
      tree-sitter
      treemacs
      treemacs-evil
      treemacs-icons-dired
      treemacs-magit
      treemacs-persp
      treemacs-projectile
      typescript-mode
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
