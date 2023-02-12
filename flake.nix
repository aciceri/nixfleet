{
  description = "A complete, declarative, and reproducible configuration of my entire Nix fleet";

  inputs = {
    nixpkgsUnstable.url = "github:NixOS/nixpkgs";
    nixpkgsStable.url = "github:NixOS/nixpkgs/nixos-22.05";
    nixosHardware.url = "github:NixOS/nixos-hardware";
    homeManager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgsUnstable";
    };
    nur.url = "github:nix-community/NUR";
    preCommitHooks.url = "github:cachix/pre-commit-hooks.nix";
    agenix.url = "github:ryantm/agenix";
    comma.url = "github:nix-community/comma";
    rock5b.url = "github:aciceri/rock5b-nixos";
    ccrEmacs.url = "path:/home/ccr/.config/emacs";
    helix.url = "github:helix-editor/helix";
    nom.url = "github:maralorn/nix-output-monitor";
  };
  outputs = {self, ...} @ inputs: let
    utils = import ./utils inputs;
    inherit
      (utils)
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

    apps = lib.foldr lib.recursiveUpdate {} [
      (mkVmApps self.nixosConfigurations)
      formatApp
    ];

    checks = checkFormatting ./.;

    devShells = mkDevShell;

    inherit formatter;
  };

  nixConfig = {
    extra-substituters = [
      "https://aciceri-fleet.cachix.org"
      "https://rock5b-nixos.cachix.org"
      "https://helix.cachix.org"
    ];
    extra-trusted-public-keys = [
      "aciceri-fleet.cachix.org-1:e1AodrwmzRWy0eQi3lUY71M41fp9Sq+UpuKKv705xsI="
      "rock5b-nixos.cachix.org-1:bXHDewFS0d8pT90A+/YZan/3SjcyuPZ/QRgRSuhSPnA="
      "helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs="
    ];
  };
}
