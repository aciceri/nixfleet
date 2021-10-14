final: prev: {
  # keep sources this first
  sources = prev.callPackage (import ./_sources/generated.nix) { };
  customEmacs = prev.callPackage (import ./emacs) { };
  # then, call packages with `final.callPackage`
}
