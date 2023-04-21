{
  config,
  lib,
  pkgs,
  ...
}: {
  nix = {
    optimise.automatic = true;

    settings = {
      auto-optimise-store = true;
      trusted-users = [
        "root"
        "ccr"
        "@wheel"
      ];
      # Disabled all the substituters, this should be managed at flakes level
      # trusted-public-keys = [
      #   "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
      #   "mlabs.cachix.org-1:gStKdEqNKcrlSQw5iMW6wFCj3+b+1ASpBVY2SYuNV2M="
      #   "aciceri-fleet.cachix.org-1:e1AodrwmzRWy0eQi3lUY71M41fp9Sq+UpuKKv705xsI="
      #   "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      # ];
      # substituters = [
      #   "https://cache.iog.io"
      #   "https://mlabs.cachix.org"
      #   "https://aciceri-fleet.cachix.org"
      #   "https://nix-community.cachix.org"
      # ];
    };

    extraOptions = ''
      experimental-features = nix-command flakes ca-derivations
    '';

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };

    buildMachines = [
      {
        hostName = "rock5b.fleet";
        system = "aarch64-linux";
        maxJobs = 6;
        speedFactor = 1;
        supportedFeatures = ["nixos-test" "benchmark" "big-parallel" "kvm"];
        mandatoryFeatures = [];
        # sshKey = "/var/lib/hydra/queue-runner/.ssh/id_rsa";
        sshUser = "root";
      }
    ];
    distributedBuilds = true;
  };
}
