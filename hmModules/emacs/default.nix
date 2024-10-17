{
  lib,
  fleetFlake,
  pkgs,
  ...
}:
let
  emacs = fleetFlake.packages.${pkgs.system}.emacs;
in
{
  home.sessionVariables.EDITOR = lib.mkForce "emacsclient -c";
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
      pkgs.qadwaitadecorations
      pkgs.kdePackages.qtwayland
    ]
    ++ (with hunspellDicts; [
      en_US-large
      it_IT
    ]);
}
