{
  description = "A complete, declarative, and reproducible configuration of my entire Nix fleet";

  inputs = {
    nixpkgsUnstable.url = github:NixOS/nixpkgs/nixos-unstable;
    nixpkgsStable.url = github:NixOS/nixpkgs/nixos-22.05;
    homeManager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgsUnstable";
    };
    preCommitHooks.url = github:cachix/pre-commit-hooks.nix;
    agenix.url = github:ryantm/agenix;
    doomEmacs.url = github:nix-community/nix-doom-emacs;
  };

  outputs = {
    self,
    nixpkgsUnstable,
    nixpkgsStable,
    homeManager,
    preCommitHooks,
    agenix,
    doomEmacs,
  } @ inputs: let
    utils = (import ./utils) inputs;
    inherit (utils) lib mkConfigurations mkVmApps checkFormatting formatter formatApp mkDevShell;
  in {
    nixosConfigurations = mkConfigurations;

    apps = lib.recursiveUpdate (mkVmApps self.nixosConfigurations) formatApp;

    checks = checkFormatting ./.;

    devShells = mkDevShell;

    inherit formatter;
  };
}
