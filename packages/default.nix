{
  inputs,
  lib,
  config,
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
      ];
    };

  config.perSystem = {
    system,
    lib,
    ...
  }: {
    _module.args.pkgs =
      lib.foldl
      (legacyPackages: legacyPackages.extend)
      inputs.nixpkgsUnstable.legacyPackages.${system}
      config.fleet.overlays;
  };
}
