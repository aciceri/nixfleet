{ nix, pkgs }:
nix.overrideAttrs (old: {
  src = pkgs.fetchFromGitHub {
    owner = "NixOS";
    repo = "nix";
    rev = "3ec979fa902c49e975a9af7dc2792fb197030e04";
    hash = "sha256-mpFR1OrjayyVe8LpxJVaTLVIPPeTSIu7SDz/wXP78Vg=";
  };
})
