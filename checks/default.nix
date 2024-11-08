{
  inputs,
  self,
  lib,
  ...
}:
{
  imports = [
    inputs.treefmt-nix.flakeModule
    inputs.git-hooks-nix.flakeModule
  ];

  perSystem =
    { ... }:
    {
      treefmt.config = {
        projectRootFile = ".git/config";
        programs = {
          nixfmt.enable = true;
          deadnix.enable = false;
        };
      };

      pre-commit.settings.hooks = {
        nixfmt-rfc-style.enable = true;
        deadnix.enable = false;
      };
    };

  flake.checks =
    let
      build = _: nc: nc.config.system.build.toplevel;
    in
    {
      x86_64-linux = lib.mapAttrs build { inherit (self.nixosConfigurations) picard; };
      aarch64-linux = lib.mapAttrs build {
        inherit (self.nixosConfigurations) sisko; # pbp;
      };
    };
}
