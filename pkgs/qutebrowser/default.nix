{ pkgs }:

pkgs.qutebrowser.overrideAttrs (old: {
  buildInputs = old.buildInputs ++ [ pkgs.makeWrapper ];
  postInstall = old.postInstall or "" + ''
    wrapProgram "$out/bin/qutebrowser" --set QT_QPA_PLATFORM wayland --set QT_WAYLAND_DISABLE_WINDOWDECORATION 1
  '';
})

