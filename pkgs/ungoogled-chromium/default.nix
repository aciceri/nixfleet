{ prev, ... }:

prev.runCommandNoCC "wrap-chromium"
{ buildInputs = with prev.pkgs; [ makeWrapper ]; }
  ''
    makeWrapper ${prev.pkgs.chromium}/bin/chromium $out/bin/chromium \
      --add-flags "--enable-features=UseOzonePlatform" \
      --add-flags "--ozone-platform=wayland"
    ln -sf ${prev.pkgs.chromium}/share $out/share
  ''
