{
  config,
  lib,
  pkgs,
  ...
}: {
  nix = {
    settings = {
      auto-optimise-store = true;
    };

    extraOptions = ''
      experimental-features = nix-command flakes ca-derivations
    '';

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };

    optimise.automatic = true;
  };
}
