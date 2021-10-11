final: prev: {
  # keep sources this first
  sources = prev.callPackage (import ./_sources/generated.nix) { };
  customEmacs = prev.callPackage (import ./emacs) { };
  ungoogled-chromium = import ./ungoogled-chromium { inherit prev; };
  vscodium = import ./vscodium { inherit prev; };
  # then, call packages with `final.callPackage`
}
