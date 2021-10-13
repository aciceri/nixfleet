{ prev, ... }:

prev.runCommandNoCC "codium"
{ buildInputs = with prev.pkgs; [ makeWrapper ]; }
  ''
    makeWrapper ${prev.pkgs.vscodium}/bin/codium $out/bin/codium \
      --add-flags "--enable-features=UseOzonePlatform" \
      --add-flags "--ozone-platform=wayland"
    ln -sf ${prev.pkgs.vscodium}/share $out/share
  ''
