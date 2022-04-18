{ nixpkgsUnstableInput, nixpkgsDevInput }:

final: prev:
let
  nixpkgsUnstable = (import nixpkgsUnstableInput {
    system = prev.system;
    config.allowUnfree = true;
  }).pkgs;
  nixpkgsDev = (import nixpkgsDevInput {
    system = prev.system;
    config.allowUnfree = true;
  }).pkgs;
in
{
  # keep sources this first
  # sources = prev.callPackage (import ./_sources/generated.nix) { };
  customEmacs = prev.callPackage (import ./emacs) { };
  amule = prev.callPackage (import ./amule) { };
  digikam = nixpkgsUnstable.digikam;
  cura = nixpkgsUnstable.cura;
  #firefox-unwrapped = nixpkgsUnstable.firefox-unwrapped;
  xdg-desktop-portal = nixpkgsUnstable.xdg-desktop-portal;
  xdg-desktop-portal-gtk = nixpkgsUnstable.xdg-desktop-portal-gtk;
  vscode = nixpkgsUnstable.vscode;
  geoclue2 = nixpkgsUnstable.geoclue2;
  gnome = nixpkgsUnstable.gnome;
  umoria = nixpkgsDev.umoria;
  # then, call packages with `final.callPackage`
}
