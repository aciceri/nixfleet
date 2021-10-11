{ prev, pkgs, ... }:

prev.runCommandNoCC "wrap-chromium"
{ buildInputs = with pkgs; [ makeWrapper ]; }
  ''
    makeWrapper ${c}/bin/chromium $out/bin/chromium \
      --add-flags "--enable-features=UseOzonePlatform" \
      --add-flags "--ozone-platform=wayland"
    ln -sf ${c}/share $out/share
  ''
