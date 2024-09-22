{
  description = "A complete, declarative, and reproducible configuration of my entire Nix fleet";

  inputs = {
    flakeParts.url = "github:hercules-ci/flake-parts";
    # FIXME remove constraint
    nixpkgs.url = "github:NixOS/nixpkgs";
    # nixpkgsForSisko.url = "github:NixOS/nixpkgs/0e74ca98a74bc7270d28838369593635a5db3260";
    nixosHardware.url = "github:NixOS/nixos-hardware";
    homeManager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # TODO: remove after https://github.com/nix-community/home-manager/pull/3811
    homeManagerGitWorkspace = {
      url = "github:aciceri/home-manager/git-workspace";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    git-hooks-nix = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix.url = "github:ryantm/agenix";
    rock5b.url = "github:aciceri/rock5b-nixos";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dream2nix.url = "github:nix-community/dream2nix";
    nixThePlanet = {
      url = "github:aciceri/NixThePlanet/nix-in-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixDarwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-on-droid.url = "github:nix-community/nix-on-droid";
    lix = {
      url = "git+https://git@git.lix.systems/lix-project/lix";
      flake = false;
    };
    lix-module = {
      url = "git+https://git.lix.systems/lix-project/nixos-module";
      inputs.lix.follows = "lix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mobile-nixos = {
      url = "github:NixOS/mobile-nixos";
      flake = false;
    };
    impermanence.url = "github:nix-community/impermanence";
    vscode-server.url = "github:nix-community/nixos-vscode-server";
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ flakeParts, ... }:
    flakeParts.lib.mkFlake { inherit inputs; } {
      imports = [
        # TODO export modules as flake outputs
        # ./modules
        # ./hmModules
        ./hosts
        ./packages
        ./shell
        ./checks
      ];
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
    };
}
