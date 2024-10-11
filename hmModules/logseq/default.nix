{ pkgs, lib, ... }:
let
  logseq = pkgs.appimageTools.wrapType2 {
    name = "logseq";
    version = "nightly-20240909";
    src = pkgs.fetchurl {
      url = "https://github.com/logseq/logseq/releases/download/nightly/Logseq-linux-x64-0.10.10-alpha+nightly.20240909.AppImage";
      hash = "sha256-Hy/zk8ZCkWajsMRUMsewLvkKpMpsBZYnFootPU9y6Z0=";
    };
  };
  logseq-wayland = pkgs.writeScriptBin "logseq" "${lib.getExe logseq} --enable-features=UseOzonePlatform --ozone-platform=wayland";
in
{
  home.packages = [ logseq-wayland ];
}
