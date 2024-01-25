{inputs, ...}: {
  perSystem = {
    pkgs,
    config,
    ...
  }: {
    devShells.default = pkgs.mkShell {
      name = "fleet-shell";
      buildInputs = with pkgs; [
        git
        agenix
        age
        deadnix
        statix
        alejandra
        disko
        deploy
        colmena
        nixos-anywhere
      ];
      shellHook = ''
        export RULES="$(git rev-parse --show-toplevel)/secrets/secrets.nix";
        ${config.pre-commit.installationScript}
      '';
    };
  };
}
