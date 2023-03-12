{inputs, ...}: {
  perSystem = {
    pkgs,
    config,
    self',
    ...
  }: {
    devShells.default = pkgs.mkShell {
      name = "fleet-shell";
      buildInputs = with pkgs; [
        git
        agenix
      ];
      shellHook = ''
        export RULES="$(git rev-parse --show-toplevel)/secrets/default.nix";
      '';
    };
  };
}
