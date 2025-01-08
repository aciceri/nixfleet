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
  pkgs-with-tree-sitter-kdl =
    (builtins.getFlake "github:aciceri/nixpkgs/23a675ee8313427610cf129dd2b52a69bf6a2a26")
    .legacyPackages.${pkgs.stdenv.system};
  # TODO remove when merged: https://github.com/NixOS/nixpkgs/pull/371287/files
  # all-grammars = pkgs'.tree-sitter.withPlugins builtins.attrValues;
  all-grammars = pkgs-with-tree-sitter-kdl.tree-sitter.withPlugins builtins.attrValues;
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
