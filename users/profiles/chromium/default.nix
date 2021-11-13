{ pkgs, ... }:
{
  programs.chromium = {
    enable = true;
    package = with pkgs; if stdenv.hostPlatform.isAarch64 then ungoogled-chromium else google-chrome;
  };
}
