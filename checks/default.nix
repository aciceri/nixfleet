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
    { pkgs, ... }:
    {
      treefmt.config = {
        projectRootFile = ".git/config";
        programs.nixfmt-rfc-style.enable = true;
      };

      pre-commit.settings.hooks = {
        nixfmt-rfc-style.enable = true;
      };

      formatter = pkgs.nixfmt-rfc-style;
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
