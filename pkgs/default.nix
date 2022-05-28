{ nixpkgsStableInput, nixpkgsDevInput }:
final: prev:
let
  config.allowUnfree = true;
  overlays = [ ];
  nixpkgsStable = (import nixpkgsStableInput {
    inherit config overlays;
    system = prev.system;
  }).pkgs;
  nixpkgsDev = (import nixpkgsDevInput {
    inherit config overlays;
    system = prev.system;
  }).pkgs;
in
{
  # keep sources this first
  # sources = prev.callPackage (import ./_sources/generated.nix) { };
  amule = prev.callPackage (import ./amule) { };
  customEmacs = prev.callPackage (import ./emacs) { pkgs = prev; };
  droidcam = prev.callPackage (import ./droidcam) { };
  google-chrome = import ./google-chrome { pkgs = prev; };
  nixFromMaster = import ./nix-from-master { nix = prev.nix; pkgs = prev; };
  qutebrowser = import ./qutebrowser { pkgs = prev; };
  slack = import ./slack { pkgs = prev; };
  umoria = nixpkgsDev.umoria;
  v4l2loopback-dc = prev.callPackage (import ./v4l2loopback-dc) { kernel = prev.linux; };
  # then, call packages with `final.callPackage`
}
