{
  config,
  pkgs,
  ...
}: let
  # use same version as Doom Emacs
  vanillaEmacs = (pkgs.emacsPackagesFor config.programs.doom-emacs.emacsPackage).emacsWithPackages (epkgs:
    with epkgs; [
      meow
      ef-themes
      vertico
      marginalia
      consult
      orderless
      embark
      embark-consult
      fira-code-mode
      vterm
      setup
      magit
      magit-delta
      # git-gutter
      # git-gutter-fringe
      corfu
      corfu-terminal
      cape
      which-key
      nix-mode
      envrc
      flycheck
      flycheck-posframe
      flycheck-inline
      consult-flycheck
      popper
      # choose one
      lispy
      paredit
      tree-sitter
      tree-sitter-langs
      yaml-mode
      hl-todo
    ]);
  vanillaEmacsBin = pkgs.writeScriptBin "vanillaEmacs" ''
    ${vanillaEmacs}/bin/emacs --init-directory ~/.vanilla-emacs.d $@
  '';
in {
  home.packages = [
    vanillaEmacsBin

    (
      pkgs.makeDesktopItem {
        name = "vanilla-emacs";
        exec = "vanillaEmacs %u";
        comment = "Vanilla Emacs";
        desktopName = "vanilla-emacs";
        type = "Application";
        mimeTypes = [];
      }
    )
  ];
}
