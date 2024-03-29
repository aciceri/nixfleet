{
  config,
  lib,
  fleetFlake,
  pkgs,
  ...
}: {
  nix = {
    optimise.automatic = true;

    package = pkgs.nixUnstable;

    settings = {
      auto-optimise-store = true;
      trusted-users = [
        "root"
        config.ccr.username
        "@wheel"
      ];
      netrc-file = "/etc/nix/netrc";
      # substituters = [
      #   "s3://cache?profile=default&region=eu-south-1&scheme=https&endpoint=cache.aciceri.dev"
      # ];
      # trusted-public-keys = [
      #   "cache.aciceri.dev~1:nJMfcBnYieY2WMbYDG0s9S5qUhU+V4RPL+X9zcxXxZY="
      # ];
    };

    extraOptions = ''
      experimental-features = nix-command flakes ca-derivations impure-derivations
      builders-use-substitutes = true
    '';

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 180d";
    };

    registry = lib.mkForce {
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
    };

    distributedBuilds = false;
    buildMachines = lib.lists.optional (config.networking.hostName == "picard") {
      hostName = "sisko.fleet";
      system = "aarch64-linux";
      maxJobs = 4;
      supportedFeatures = ["kvm" "nixos-test" "big-parallel" "benchmark"];
      protocol = "ssh-ng";
      sshUser = "root";
      sshKey = "/home/${config.ccr.username}/.ssh/id_rsa";
    };
    # ++ (lib.lists.optional (config.networking.hostName == "picard") {
    #   hostName = "mac.staging.mlabs.city";
    #   system = "x86_64-darwin";
    #   maxJobs = 4;
    #   supportedFeatures = ["kvm" "nixos-test" "big-parallel" "benchmark"];
    #   protocol = "ssh-ng";
    #   sshUser = "root";
    #   sshKey = "/home/${config.ccr.username}/.ssh/id_rsa";
    # });
  };
}
