{
  config,
  lib,
  fleetFlake,
  pkgs,
  ...
}: {
  nix = {
    optimise.automatic = true;

    # Commented out otherwise Lix is not set
    # package = pkgs.nixVersions.latest;

    settings = {
      auto-optimise-store = true;
      trusted-users = [
        "root"
        "@wheel"
      ];
      netrc-file = "/etc/nix/netrc";
      substituters = [
        #   "s3://cache?profile=default&region=eu-south-1&scheme=https&endpoint=cache.aciceri.dev"
        "https://cache.iog.io"
        "https://cache.lix.systems"
        "https://nix-community.cachix.org"
        "https://mlabs.cachix.org"
      ];
      trusted-public-keys = [
        #   "cache.aciceri.dev~1:nJMfcBnYieY2WMbYDG0s9S5qUhU+V4RPL+X9zcxXxZY="
        "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
        "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "mlabs.cachix.org-1:gStKdEqNKcrlSQw5iMW6wFCj3+b+1ASpBVY2SYuNV2M="
      ];
    };

    nixPath = ["nixpkgs=${fleetFlake.inputs.nixpkgsUnstable}"];

    extraOptions = ''
      experimental-features = nix-command flakes ca-derivations impure-derivations
      builders-use-substitutes = true
    '';

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 180d";
    };

    registry = lib.mkForce ({
        nixpkgs.to = {
          type = "path";
          path = fleetFlake.inputs.nixpkgsUnstable;
        };
        nixpkgsUnstable.to = {
          type = "path";
          path = fleetFlake.inputs.nixpkgsUnstable;
        };
        nixpkgsStable.to = {
          type = "path";
          path = fleetFlake.inputs.nixpkgsStable;
        };
        n.to = {
          type = "path";
          path = fleetFlake.inputs.nixpkgsUnstable;
        };
      }
      // (lib.optionalAttrs (builtins.hasAttr "ccr" config) {
        nixfleet.to = {
          type = "path";
          path = "/home/${config.ccr.username}/projects/aciceri/nixfleet";
        };
        fleet.to = {
          type = "path";
          path = "/home/${config.ccr.username}/projects/aciceri/nixfleet";
        };
        ccrEmacs.to = {
          type = "path";
          path = "/home/${config.ccr.username}/.config/emacs";
        };
      }));

    distributedBuilds = true;
    buildMachines =
      lib.lists.optional (config.networking.hostName == "picard") {
        hostName = "sisko.fleet";
        system = "aarch64-linux";
        maxJobs = 7;
        supportedFeatures = ["kvm" "nixos-test" "big-parallel" "benchmark"];
        protocol = "ssh-ng";
        sshUser = "root";
        sshKey = "/home/${config.ccr.username}/.ssh/id_rsa";
      }
      ++ (lib.lists.optional (config.networking.hostName == "picard") {
        hostName = "mac.staging.mlabs.city";
        system = "x86_64-darwin";
        maxJobs = 4;
        supportedFeatures = ["kvm" "nixos-test" "big-parallel" "benchmark"];
        protocol = "ssh-ng";
        sshUser = "root";
        sshKey = "/home/${config.ccr.username}/.ssh/id_rsa";
      });
  };
}
