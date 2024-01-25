{
  description = "A complete, declarative, and reproducible configuration of my entire Nix fleet";

  inputs = {
    flakeParts.url = "github:hercules-ci/flake-parts";
    nixpkgsUnstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgsStable.url = "github:NixOS/nixpkgs/nixos-23.11";
    nixosHardware.url = "github:NixOS/nixos-hardware";
    homeManager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgsUnstable";
    };
    # TODO: remove after https://github.com/nix-community/home-manager/pull/3811
    homeManagerGitWorkspace = {
      url = "github:aciceri/home-manager/git-workspace";
      inputs.nixpkgs.follows = "nixpkgsUnstable";
    };
    # TODO: remove after https://github.com/nix-community/home-manager/pull/4249
    homeManagerSwayNC = {
      url = "github:rhoriguchi/home-manager/swaync";
      inputs.nixpkgs.follows = "nixpkgsUnstable";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgsUnstable";
    };
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs = {
        nixpkgs.follows = "nixpkgsUnstable";
        nixpkgs-stable.follows = "nixpkgsStable";
      };
    };
    nur.url = "github:nix-community/NUR";
    agenix.url = "github:ryantm/agenix";
    rock5b.url = "github:aciceri/rock5b-nixos";
    # ccrEmacs.url = "ccrEmacs";
    ccrEmacs.url = "github:aciceri/emacs";
    # ccrEmacs.url = "/home/ccr/.config/emacs";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgsUnstable";
    };
    hercules-ci-effects.url = "github:hercules-ci/hercules-ci-effects";
    dream2nix.url = "github:nix-community/dream2nix";
  };

  outputs = inputs @ {flakeParts, ...}:
    flakeParts.lib.mkFlake {inherit inputs;} {
      imports = [
        # TODO export modules as flake outputs
        # ./modules
        # ./hmModules
        ./hosts
        ./packages
        ./shell
        # ./checks
        ./ci
      ];
      systems = ["x86_64-linux" "aarch64-linux"];
    };

  nixConfig = {};
}
