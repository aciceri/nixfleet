{ pkgs, ... }:
let
  reinstall-magisk-on-lineage = pkgs.stdenv.mkDerivation {
    name = "reinstall-magisk-on-lineage";
    version = "git";
    src = pkgs.fetchFromGitHub {
      owner = "NicolasWebDev";
      repo = "reinstall-magisk-on-lineageos";
      rev = "1ca911ed555d4badd705c6c71750b78be8962b0b";
      hash = "sha256-95LzcWL4efR77i8UlzIT+7wQXp+91K2sUwcjmHvTf+Q=";
    };
    propagatedBuildInputs = with pkgs; [
      android-tools
      jq
    ];
    installPhase = ''
      mkdir -p $out/bin
      cp reinstall-magisk-on-lineageos $out/bin/reinstall-magisk-on-lineageos
    '';
    patchPhase = ''
      substituteInPlace reinstall-magisk-on-lineageos \
        --replace-fail "paste_yours_here" "\"\$1\""
    '';
  };
in
{
  home.packages = [ reinstall-magisk-on-lineage ];
}
