{ pkgs }:

pkgs.slack.overrideAttrs (old: {
  buildInputs = old.buildInputs ++ [ pkgs.makeWrapper ];
  postInstall = old.postInstall or "" + ''
    rm $out/bin/slack
    makeWrapper $out/lib/slack/slack $out/bin/slack \
      --prefix XDG_DATA_DIRS : $GSETTINGS_SCHEMAS_PATH \
      --prefix PATH : ${pkgs.lib.makeBinPath [pkgs.xdg-utils]} \
      --add-flags "--ozone-platform=wayland --enable-features=UseOzonePlatform,WebRTCPipeWireCapturer"
  '';
})
