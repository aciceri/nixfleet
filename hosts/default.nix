{
  self,
  lib,
  config,
  inputs,
  ...
}: {
  options.fleet = {
    hosts = lib.mkOption {
      description = "Host configuration";
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          name = lib.mkOption {
            description = "Host name";
            type = lib.types.strMatching "^$|^[[:alnum:]]([[:alnum:]_-]{0,61}[[:alnum:]])?$";
          };
          system = lib.mkOption {
            description = "NixOS architecture (a.k.a. system)";
            type = lib.types.str;
            default = "x86_64-linux";
          };
          secrets = lib.mkOption {
            description = "List of secrets names in the `secrets` folder";
            type = lib.types.listOf lib.types.str;
            default = [];
          };
          enableHomeManager = lib.mkOption {
            description = "Enable home-manager module";
            type = lib.types.bool;
            default = true;
          };
          overlays = lib.mkOption {
            description = "Enabled Nixpkgs overlays";
            type = lib.types.listOf (lib.mkOptionType {
              name = "nixpkgs-overlay";
              description = "nixpkgs overlay";
              check = lib.isFunction;
              merge = lib.mergeOneOption;
            });
            default = with inputs; [
              agenix.overlays.default
              comma.overlays.default
              nur.overlay
              nil.overlays.default # FIXME This shouldn't be here
            ];
          };
          extraModules = lib.mkOption {
            description = "Extra NixOS modules";
            type = lib.types.listOf lib.types.deferredModule;
            default = [];
          };
          extraHmModules = lib.mkOption {
            description = "Extra home-manager modules";
            type = lib.types.listOf lib.types.deferredModule;
            default = [];
          };
          extraHmModulesUser = lib.mkOption {
            description = "User for which to import extraHmModulesUser";
            type = lib.types.str;
            default = "ccr";
          };
        };
      });
      default = {};
    };
    _mkNixosConfiguration = lib.mkOption {
      description = "Function returning a proper NixOS configuration";
      type = lib.types.functionTo (lib.types.functionTo lib.types.attrs); # TODO improve this type
      internal = true;
      default = hostname: config:
        inputs.nixpkgsUnstable.lib.nixosSystem {
          inherit (config) system;
          modules =
            [
              ({lib, ...}: {
                networking.hostName = lib.mkForce hostname;
                nixpkgs.overlays = config.overlays;
              })
              "${self.outPath}/hosts/${hostname}"
            ]
            ++ (lib.optionals (config.secrets != []) [
              inputs.agenix.nixosModules.default
              ({lib, ...}: {
                age.secrets =
                  lib.filterAttrs
                  (name: _: builtins.elem name config.secrets)
                  (lib.mapAttrs' (name: _: {
                    name = lib.removeSuffix ".age" (builtins.baseNameOf name);
                    value.file = "${self.outPath}/${name}";
                  }) (import "${self.outPath}/secrets"));
              })
            ])
            ++ (lib.optionals config.enableHomeManager [
              inputs.homeManager.nixosModule
              {home-manager.users."${config.extraHmModulesUser}".imports = config.extraHmModules;}
            ])
            ++ config.extraModules;
          specialArgs = {
            fleetModules = builtins.map (moduleName: "${self.outPath}/modules/${moduleName}");
            fleetHmModules = builtins.map (moduleName: "${self.outPath}/hmModules/${moduleName}");
            fleetFlake = self;
          };
        };
    };
  };

  # TODO Add per host:
  # - apps to run as VMs
  # - checks
  # - deploy scripts (`nixos-rebuild`)

  config = {
    fleet.hosts = {
      # TODO add `hs` and `pbp`
      thinkpad = {
        extraModules = [inputs.nixosHardware.nixosModules.lenovo-thinkpad-x1-7th-gen];
        extraHmModules = [
          inputs.ccrEmacs.hmModules.default
        ];
        secrets = ["cachix"];
      };
      rock5b = {
        system = "aarch64-linux";
        extraModules = [inputs.rock5b.nixosModules.default];
      };
      pbp = {
        system = "aarch64-linux";
        extraModules = with inputs; [
          nixosHardware.nixosModules.pine64-pinebook-pro
          disko.nixosModules.disko
        ];
        extraHmModules = [
          inputs.ccrEmacs.hmModules.default
        ];
      };
    };

    flake.nixosConfigurations =
      lib.mapAttrs
      config.fleet._mkNixosConfiguration
      config.fleet.hosts;
  };
}
