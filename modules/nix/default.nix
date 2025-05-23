{
  config,
  lib,
  fleetFlake,
  pkgs,
  ...
}:
{
  environment.systemPackages = [ pkgs.nix-fast-build ];

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
      netrc-file = config.age.secrets.nix-netrc.path;
      substituters = [
        "https://cache.iog.io"
        "https://cache.lix.systems"
        "https://nix-community.cachix.org"
        # "https://mlabs.cachix.org"
        "http://sisko.wg.aciceri.dev:8081/nixfleet"
      ];
      trusted-public-keys = [
        "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
        "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        # "mlabs.cachix.org-1:gStKdEqNKcrlSQw5iMW6wFCj3+b+1ASpBVY2SYuNV2M="
        "nixfleet:Bud23440n6mMTmgq/7U+mk91zlLjnx2X3lQQrCBCCU4="
      ];
      deprecated-features = [ "url-literals" ];
    };

    nixPath = [ "nixpkgs=${fleetFlake.inputs.nixpkgs}" ];

    extraOptions = ''
      experimental-features = nix-command flakes impure-derivations
      builders-use-substitutes = true
    '';

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 180d";
    };

    registry = lib.mkForce (
      {
        nixpkgs.to = {
          type = "path";
          path = fleetFlake.inputs.nixpkgs;
        };
        n.to = {
          type = "path";
          path = fleetFlake.inputs.nixpkgs;
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
      })
    );

    distributedBuilds = true;
    buildMachines =
      lib.lists.optional (config.networking.hostName == "picard") {
        hostName = "sisko.wg.aciceri.dev";
        system = "aarch64-linux";
        maxJobs = 7;
        supportedFeatures = [
          "kvm"
          "nixos-test"
          "big-parallel"
          "benchmark"
        ];
        protocol = "ssh-ng";
        sshUser = "root";
        sshKey = "/home/${config.ccr.username}/.ssh/id_ed25519";
      }
      ++ (lib.lists.optional (config.networking.hostName == "picard") {
        hostName = "mac.staging.mlabs.city?remote-program=/run/current-system/sw/bin/nix-store";
        system = "x86_64-darwin";
        maxJobs = 4;
        supportedFeatures = [
          "kvm"
          "nixos-test"
          "big-parallel"
          "benchmark"
        ];
        protocol = "ssh";
        sshUser = "root";
        sshKey = "/home/${config.ccr.username}/.ssh/id_rsa";
      });
  };
}
