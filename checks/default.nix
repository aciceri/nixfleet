{
  inputs,
  self,
  lib,
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

  flake.checks = let
    build = _: nc: nc.config.system.build.toplevel;
  in {
    x86_64-linux = lib.mapAttrs build {
      inherit (self.nixosConfigurations) picard;
    };
    aarch64-linux = {
      inherit (self.nixosConfigurations) rock5b; #pbp;
    };
  };
}
