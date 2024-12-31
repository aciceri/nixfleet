{
  lib,
  inputs,
  pkgs,
  ...
}:
let
  pkgs' = pkgs.extend (
    lib.composeManyExtensions [
      inputs.emacs-overlay.overlays.package
      inputs.emacs-overlay.overlays.emacs
    ]
  );
  all-grammars = pkgs'.tree-sitter.withPlugins builtins.attrValues;
  treesitGrammars = pkgs'.runCommand "treesit-grammars" { } ''
    mkdir $out
    for f in ${all-grammars}/*
    do
      cp $f $out/"libtree-sitter-$(basename $f)"
    done
  '';
  emacsWithoutPackages = pkgs'.emacs-unstable.override {
    withSQLite3 = true;
    withWebP = true;
    withPgtk = true;
  };
  emacs = (pkgs'.emacsPackagesFor emacsWithoutPackages).emacsWithPackages (
    import ./packages.nix pkgs'
  );
in
emacs.overrideAttrs {
  passthru = {
    inherit treesitGrammars;
  };
}
