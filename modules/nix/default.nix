{
  config,
  lib,
  pkgs,
  ...
}: {
  nix = {
    settings = {
      auto-optimise-store = true;
      trusted-users = [
        "root"
        "ccr"
        "@wheel"
      ];
      trusted-public-keys = [
        "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
        "mlabs.cachix.org-1:gStKdEqNKcrlSQw5iMW6wFCj3+b+1ASpBVY2SYuNV2M="
        "aciceri-fleet.cachix.org-1:e1AodrwmzRWy0eQi3lUY71M41fp9Sq+UpuKKv705xsI="
      ];
      substituters = [
        "https://cache.iog.io"
        "https://mlabs.cachix.org"
        "httos://aciceri-fleet.cachix.org"
      ];
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

  age.secrets.mlabs-cachix.file = ../../secrets/mlabs-cachix.age;
  system.activationScripts = {
    populate-netrc.text = ''
      cat <<EOF> /etc/nix/netrc
      machine mlabs.cachix.org login "" password "$(cat ${config.age.secrets.mlabs-cachix.path})"
      EOF
    '';
  };
}
