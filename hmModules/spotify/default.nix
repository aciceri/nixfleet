{pkgs, ...}: let
  spotify-adblock = pkgs.rustPlatform.buildRustPackage {
    pname = "spotify-adblock";
    version = "1.0.2";
    src = pkgs.fetchFromGitHub {
      owner = "abba23";
      repo = "spotify-adblock";
      rev = "v1.0.2";
      sha256 = "YGD3ymBZ2yT3vrcPRS9YXcljGNczJ1vCvAXz/k16r9Y=";
    };

    cargoSha256 = "bYqkCooBfGeHZHl2/9Om+0qbudyOCzpvwMhy8QCsPRE=";
  };

  spotify-adblocked = pkgs.callPackage ./spotify-adblocked.nix {
    inherit spotify-adblock;
  };
  # spotify-adblocked = pkgs.spotify.overrideAttrs (_: {
  #   preInstallPhase = ''
  #     ln -s ${spotify-adblock}/lib/libspotifyadblock.so $out/lib/spotify/
  #     # wrapProgram $out/bin/spotify \
  #     #   --set LD_PRELOAD ${spotify-adblock}/lib/libspotifyadblock.so
  #   '';
  # });
in {
  home.packages = [spotify-adblocked];
}
