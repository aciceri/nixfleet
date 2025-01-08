{
  lib,
  fleetFlake,
  pkgs,
  age,
  ...
}:
let
  emacs = fleetFlake.packages.${pkgs.system}.emacs;
  inherit (emacs.passthru) treesitGrammars;
in
{
  systemd.user.sessionVariables = {
    EDITOR = lib.mkForce "emacsclient -c";
    OPENAI_API_KEY_PATH = age.secrets.chatgpt-token.path;
  };
  programs.emacs = {
    enable = true;
    package = emacs;
  };
  services.emacs = {
    enable = true;
    client.enable = true;
    defaultEditor = true;
    socketActivation.enable = false;
    startWithUserSession = true;
    package = emacs;
  };
  home.packages =
    with pkgs;
    [
      binutils
      delta
      (ripgrep.override { withPCRE2 = true; })
      gnutls
      fd
      hunspell
      python3
      imagemagick
      ghostscript_headless
      mupdf-headless
      poppler_utils
      ffmpegthumbnailer
      mediainfo
      unzipNLS
      nodejs_20
      qadwaitadecorations
      kdePackages.qtwayland
      copilot-node-server
    ]
    ++ (with hunspellDicts; [
      en_US-large
      it_IT
    ]);
  home.activation.linkEmacsConfig = lib.hm.dag.entryAnywhere ''
    if [ ! -d "$HOME/.config/emacs" ]; then
      $DRY_RUN_CMD mkdir "$HOME/.config/emacs"
      $DRY_RUN_CMD ln -s "$HOME/projects/aciceri/nixfleet/hmModules/emacs/init.el" "$HOME/.config/emacs/init.el"
      $DRY_RUN_CMD ln -s "$HOME/.config/emacs" "$HOME/emacs"
    fi
    $DRY_RUN_CMD ln -sfn ${treesitGrammars} "$HOME/.config/emacs/tree-sitter"
  '';
}
