{
  config,
  lib,
  fleetFlake,
  ...
}: {
  nix = {
    optimise.automatic = true;

    settings = {
      auto-optimise-store = true;
      trusted-users = [
        "root"
        config.ccr.username
        "@wheel"
      ];
      netrc-file = "/etc/nix/netrc";
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
  };
}
