{ prev, pkgs, ... }:

prev.runCommandNoCC "codium"
{ buildInputs = with pkgs; [ makeWrapper ]; }
  ''
    makeWrapper ${prev.vscodium}/bin/codium $out/bin/codium \
      --add-flags "--enable-features=UseOzonePlatform" \
      --add-flags "--ozone-platform=wayland"
    ln -sf ${prev.vscodium}/share $out/share
  ''
