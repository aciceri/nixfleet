{
  description = "A complete, declarative, and reproducible configuration of my entire Nix fleet";

  inputs = {
    flakeParts.url = "github:hercules-ci/flake-parts";
    nixpkgsUnstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgsStable.url = "github:NixOS/nixpkgs/nixos-22.11";
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
    nur.url = "github:nix-community/NUR";
    agenix.url = "github:ryantm/agenix";
    comma.url = "github:nix-community/comma";
    rock5b.url = "github:aciceri/rock5b-nixos";
    # ccrEmacs.url = "github:aciceri/emacs";
    ccrEmacs.url = "/home/ccr/.config/emacs";
    hyprland = {
      url = "github:hyprwm/hyprland";
      inputs.nixpkgs.follows = "nixpkgsUnstable";
    };
    hyprpaper = {
      url = "github:hyprwm/hyprpaper";
      inputs.nixpkgs.follows = "nixpkgsUnstable";
    };
    colmena = {
      url = "github:zhaofengli/colmena";
      inputs = {
        nixpkgs.follows = "nixpkgsUnstable";
        stable.follows = "nixpkgsStable";
      };
    };
    nix-serve-ng = {
      url = "github:aristanetworks/nix-serve-ng";
      inputs.nixpkgs.follows = "nixpkgsUnstable";
    };
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgsUnstable";
    };
    hydra.url = "github:NixOS/hydra";
    nixos-vscode-server.url = "github:msteen/nixos-vscode-server";
    helix.url = "github:helix-editor/helix";
    nil.url = "github:oxalica/nil";
    nom.url = "github:maralorn/nix-output-monitor";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgsUnstable";
    };
    statix = {
      url = "github:nerdypepper/statix";
      inputs.nixpkgs.follows = "nixpkgsUnstable";
    };
    deadnix = {
      url = "github:astro/deadnix";
      inputs.nixpkgs.follows = "nixpkgsUnstable";
    };
    alejandra = {
      url = "github:kamadorueda/alejandra";
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
      ];
      systems = ["x86_64-linux" "aarch64-linux"];
    };

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://aciceri-fleet.cachix.org"
      "https://aciceri-emacs.cachix.org"
      "https://rock5b-nixos.cachix.org"
      "https://helix.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "aciceri-fleet.cachix.org-1:e1AodrwmzRWy0eQi3lUY71M41fp9Sq+UpuKKv705xsI="
      "aciceri-emacs.cachix.org-1:kxDGDFWV6LUj41tb8xmPRBI56UJSZOVveN49LZDUKdA="
      "rock5b-nixos.cachix.org-1:bXHDewFS0d8pT90A+/YZan/3SjcyuPZ/QRgRSuhSPnA="
      "helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs="
    ];
  };
}
