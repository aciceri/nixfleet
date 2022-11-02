{
  description = "A complete, declarative, and reproducible configuration of my entire Nix fleet";

  inputs = {
    nixpkgsUnstable.url = github:NixOS/nixpkgs/nixos-unstable;
    nixpkgsStable.url = github:NixOS/nixpkgs/nixos-22.05;
    nixosHardware.url = github:NixOS/nixos-hardware;
    homeManager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgsUnstable";
    };
    preCommitHooks.url = github:cachix/pre-commit-hooks.nix;
    agenix.url = github:ryantm/agenix;
    doomEmacs.url = github:nix-community/nix-doom-emacs;
    comma.url = github:nix-community/comma;
    robotnix.url = github:atemu/robotnix/update/lineageos;
  };

  outputs = {self, ...} @ inputs: let
    utils = import ./utils inputs;
    inherit
      (utils)
      androidGenerateKeysScripts
      androidImages
      checkFormatting
      formatApp
      formatter
      lib
      mkDevShell
      mkVmApps
      nixosConfigurations
      ;
  in {
    inherit nixosConfigurations;

    packages = androidImages;

    apps = lib.foldr lib.recursiveUpdate {} [
      (mkVmApps self.nixosConfigurations)
      formatApp
      androidGenerateKeysScripts
    ];

    checks = checkFormatting ./.;

    devShells = mkDevShell;

    inherit formatter;
  };
}
