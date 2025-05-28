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
    { config, pkgs, ... }:
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
      packages.push-to-cache =
        let
          allChecks = with self.checks; x86_64-linux // aarch64-linux;
          checks = builtins.removeAttrs allChecks [ "push-to-cache" ];
        in
        pkgs.writeShellScriptBin "push-to-cache.sh" ''
          attic push $1 --stdin --jobs 64 << EOF
          ${lib.concatStringsSep "\n" (
            builtins.map (builtins.unsafeDiscardStringContext) (builtins.attrValues checks)
          )}
          EOF
        '';
    };

  flake.checks =
    let
      build = _: nc: nc.config.system.build.toplevel;
    in
    {
      x86_64-linux = (lib.mapAttrs build { inherit (self.nixosConfigurations) picard pike kirk; });
      aarch64-linux = lib.mapAttrs build {
        inherit (self.nixosConfigurations) sisko; # pbp;
      };
    };
}
