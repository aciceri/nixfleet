{ unstablePkgsInput }:



final: prev:
let
  unstablePkgs = (import unstablePkgsInput {
    system = prev.system;
  }).pkgs;
in
{
  # keep sources this first
  # sources = prev.callPackage (import ./_sources/generated.nix) { };
  customEmacs = prev.callPackage (import ./emacs) { };
  amule = prev.callPackage (import ./amule) { };
  digikam = unstablePkgs.digikam;
  cura = unstablePkgs.cura;
  firefox-unwrapped = unstablePkgs.firefox-unwrapped;
  geoclue2 = unstablePkgs.geoclue2;
  gnome = unstablePkgs.gnome;
  # then, call packages with `final.callPackage`
}
