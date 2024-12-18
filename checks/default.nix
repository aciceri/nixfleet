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
    { config, ... }:
    {
      treefmt.config = {
        projectRootFile = ".git/config";
        flakeFormatter = true;
        flakeCheck = true;
        programs = {
          nixfmt.enable = true;
          prettier.enable = true;
          black.enable = true;
          shfmt.enable = true;
        };
        settings.global.excludes = [
          "*.age"
          "*.svg"
          "*.png"
          "*.jpg"
          "*.bin"
          "*.el"
          "*.org"
          ".envrc"
          "*.conf"
        ];
      };

      pre-commit.settings = {
        hooks.treefmt = {
          enable = true;
          package = config.treefmt.build.wrapper;
        };
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
