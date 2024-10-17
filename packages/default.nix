{
  inputs,
  lib,
  config,
  self,
  ...
}:
{
  options.fleet = {
    overlays =
      let
        overlayType = lib.mkOptionType {
          name = "nixpkgs-overlay";
          description = "nixpkgs overlay";
          check = lib.isFunction;
          merge = lib.mergeOneOption;
        };
      in
      lib.mkOption {
        description = "Nixpkgs overlays to apply at flake level (not in hosts)";
        type = lib.types.listOf overlayType;
        default = with inputs; [
          agenix.overlays.default
          (final: _: {
            inherit (disko.packages.${final.system}) disko;
            inherit (self.packages.${final.system}) deploy;
            inherit (self.packages.${final.system}) llm-workflow-engine;
          })
        ];
      };
    brokenPackages = lib.mkOption {
      description = "Packages that are broken on a given system";
      type = lib.types.attrsOf (lib.types.listOf lib.types.str);
      default = {
        aarch64-linux = [ "llm-workflow-engine" ];
        x86_64-linux = [ ];
      };
    };
  };

  config.perSystem =
    {
      system,
      lib,
      pkgs,
      ...
    }:
    {
      _module.args.pkgs = lib.foldl (
        legacyPackages: legacyPackages.extend
      ) inputs.nixpkgs.legacyPackages.${system} config.fleet.overlays;

      packages = builtins.removeAttrs (lib.mapAttrs'
        (name: value: {
          inherit name;
          value = pkgs.callPackage "${self}/packages/${name}" {
            dream2nix = inputs.dream2nix;
            projectRoot = self.outPath;
            packagePath = "packages/${name}";
            inherit inputs;
          };
        })
        (lib.filterAttrs (_: type: type == "directory") (builtins.readDir "${self}/packages"))
      ) config.fleet.brokenPackages.${system};
    };
}
