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
      use-package
      evil
      evil-collection
      helm
      projectile
      helm-projectile
      magit
      company
      helm-company
      helm-ag
      fira-code-mode
      org-superstar
      org-roam
      org-download
      visual-fill-column
      writegood-mode
      nix-mode
      lsp-python-ms
      lispy
      lsp-mode
      dap-mode
      which-key
      sudo-utils
      rainbow-delimiters
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
      minimap
    ]
  ) ++ (
    with pkgs; []
  )
)
