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
}
