{
  description = "A complete, declarative, and reproducible configuration of my entire Nix fleet";

  inputs = {
    flakeParts.url = "github:hercules-ci/flake-parts";
    nixpkgsUnstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgsUnstableForSisko.url = "github:NixOS/nixpkgs/0e74ca98a74bc7270d28838369593635a5db3260";
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
    # FIXME go back to master after nltch's repository is re-added
    nur.url = "github:nix-community/NUR/324a5f3b9fbfdb77336dc9fa1c0a02f33a6acf6d";
    agenix.url = "github:ryantm/agenix";
    rock5b.url = "github:aciceri/rock5b-nixos";
    ccrEmacs.url = "git+https://git.aciceri.dev/aciceri/emacs.git";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgsUnstable";
    };
    hercules-ci-effects.url = "github:hercules-ci/hercules-ci-effects";
    dream2nix.url = "github:nix-community/dream2nix";
    hercules-ci-agent.url = "github:hercules-ci/hercules-ci-agent";
    nix-fast-build = {
      url = "github:Mic92/nix-fast-build";
      inputs.nixpkgs.follows = "nixpkgsUnstable";
    };
    nixThePlanet = {
      url = "github:aciceri/NixThePlanet/nix-in-darwin";
      inputs.nixpkgs.follows = "nixpkgsUnstable";
    };
    nixDarwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgsUnstable";
    };
    nix-on-droid.url = "github:nix-community/nix-on-droid";
    nixd.url = "github:nix-community/nixd";
    lix = {
      # url = "git+https://git@git.lix.systems/lix-project/lix?ref=refs/tags/2.90-beta.1";
      url = "git+https://git@git.lix.systems/lix-project/lix";
      flake = false;
    };
    lix-module = {
      url = "git+https://git.lix.systems/lix-project/nixos-module";
      inputs.lix.follows = "lix";
      inputs.nixpkgs.follows = "nixpkgsUnstable";
    };
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
        ./checks
        ./ci
      ];
      systems = ["x86_64-linux" "aarch64-linux"];
    };
}
