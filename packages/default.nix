{
  inputs,
  lib,
  config,
  self,
  ...
}: {
  options.fleet.overlays = let
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
        comma.overlays.default
        nur.overlay
        deadnix.overlays.default
        statix.overlays.default
        nil.overlays.default
        alejandra.overlays.default
        (final: _: {
          inherit (disko.packages.${final.system}) disko;
          inherit (self.packages.${final.system}) deploy;
        })
      ];
    };

  config.perSystem = {
    system,
    lib,
    pkgs,
    ...
  }: {
    _module.args.pkgs =
      lib.foldl
      (legacyPackages: legacyPackages.extend)
      inputs.nixpkgsUnstable.legacyPackages.${system}
      config.fleet.overlays;

    packages =
      lib.mapAttrs'
      (name: value: {
        inherit name;
        value = pkgs.callPackage "${self}/packages/${name}" {};
      })
      (lib.filterAttrs
        (_: type: type == "directory")
        (builtins.readDir "${self}/packages"));
  };
}
