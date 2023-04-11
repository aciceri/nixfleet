{
  inputs,
  self,
  ...
}: {
  imports = [
    inputs.treefmt-nix.flakeModule
    inputs.pre-commit-hooks.flakeModule
  ];

  perSystem = _: {
    treefmt.config = {
      projectRootFile = ".git/config";
      programs.alejandra.enable = true;
    };

    pre-commit.settings.hooks = {
      alejandra.enable = true;
      # deadnix.enable = true;
      # statix.enable = true;
    };
  };

  flake.checks.x86_64-linux =
    builtins.mapAttrs
    (_: nc: nc.config.system.build.toplevel)
    self.nixosConfigurations;
}
