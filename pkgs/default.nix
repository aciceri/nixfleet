final: prev: {
  # keep sources this first
  # sources = prev.callPackage (import ./_sources/generated.nix) { };
  customEmacs = prev.callPackage (import ./emacs) { };
  amule = prev.callPackage (import ./amule) { };
  # then, call packages with `final.callPackage`
}
