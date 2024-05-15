# TODO Add per host:
# - apps to run as VMs
# - checks
# - deploy scripts (`nixos-rebuild`)
{
  self,
  lib,
  config,
  inputs,
  ...
} @ flakePartsArgs: let
  cfg = config.fleet;
in {
  options.fleet = {
    darwinHosts = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule ({name, ...}: {
        options = {
          name = lib.mkOption {
            description = "Host name";
            type = lib.types.strMatching "^$|^[[:alnum:]]([[:alnum:]_-]{0,61}[[:alnum:]])?$";
            default = name;
          };
          system = lib.mkOption {
            description = "NixOS architecture (a.k.a. system)";
            type = lib.types.str;
            default = "x86_64-darwin";
          };
          nixpkgs = lib.mkOption {
            description = "Used nixpkgs";
            type = lib.types.anything;
            default = inputs.nixpkgsUnstable;
          };
          extraModules = lib.mkOption {
            description = "Extra NixOS modules";
            type = lib.types.listOf lib.types.deferredModule;
            default = [];
          };
          overlays = lib.mkOption {
            description = "Enabled Nixpkgs overlays";
            type = lib.types.listOf (lib.mkOptionType {
              name = "nixpkgs-overlay";
              description = "nixpkgs overlay";
              check = lib.isFunction;
              merge = lib.mergeOneOption;
            });
            default = [];
          };
        };
      }));
    };
    nixOnDroidHosts = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule ({name, ...}: {
        options = {
          name = lib.mkOption {
            description = "Host name";
            type = lib.types.strMatching "^$|^[[:alnum:]]([[:alnum:]_-]{0,61}[[:alnum:]])?$";
            default = name;
          };
          system = lib.mkOption {
            description = "NixOS architecture (a.k.a. system)";
            type = lib.types.str;
            default = "aarch64-linux";
          };
          nixpkgs = lib.mkOption {
            description = "Used nixpkgs";
            type = lib.types.anything;
            default = inputs.nixpkgsUnstable;
          };
          extraModules = lib.mkOption {
            description = "Extra NixOS modules";
            type = lib.types.listOf lib.types.deferredModule;
            default = [];
          };
          overlays = lib.mkOption {
            description = "Enabled Nixpkgs overlays";
            type = lib.types.listOf (lib.mkOptionType {
              name = "nixpkgs-overlay";
              description = "nixpkgs overlay";
              check = lib.isFunction;
              merge = lib.mergeOneOption;
            });
            default = [];
          };
        };
      }));
    };
    hosts = lib.mkOption {
      description = "Host configuration";
      type = lib.types.attrsOf (lib.types.submodule ({name, ...}: {
        options = {
          name = lib.mkOption {
            description = "Host name";
            type = lib.types.strMatching "^$|^[[:alnum:]]([[:alnum:]_-]{0,61}[[:alnum:]])?$";
            default = name;
          };
          system = lib.mkOption {
            description = "NixOS architecture (a.k.a. system)";
            type = lib.types.str;
            default = "x86_64-linux";
          };
          nixpkgs = lib.mkOption {
            description = "Used nixpkgs";
            type = lib.types.anything;
            default = inputs.nixpkgsUnstable;
          };
          vpn = {
            ip = lib.mkOption {
              description = "Wireguard VPN ip";
              type = lib.types.str;
            };
            publicKey = lib.mkOption {
              description = "Wireguard public key";
              type = lib.types.str;
            };
          };
          secrets = lib.mkOption {
            description = "List of secrets names in the `secrets` folder";
            type = lib.types.attrsOf (lib.types.submodule ({name, ...}: {
              options = {
                owner = lib.mkOption {
                  type = lib.types.str;
                  default = "root";
                };
                group = lib.mkOption {
                  type = lib.types.str;
                  default = "root";
                };
                file = lib.mkOption {
                  type = lib.types.path;
                  default = "${self.outPath}/secrets/${name}.age";
                };
                mode = lib.mkOption {
                  # TODO improve type
                  type = lib.types.str;
                  default = "0440";
                };
              };
            }));
            default = {};
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
            default = [];
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
        config.overlays = with inputs;
          [
            nur.overlay
          ]
          ++ cfg.overlays;
      }));
      default = {};
    };
    vpnExtra = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          ip = lib.mkOption {
            description = "Wireguard VPN ip";
            type = lib.types.str;
          };
          publicKey = lib.mkOption {
            description = "Wireguard public key";
            type = lib.types.str;
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
        config.nixpkgs.lib.nixosSystem {
          inherit (config) system;
          modules =
            [
              ({lib, ...}: {
                networking.hostName = lib.mkForce hostname;
                nixpkgs.overlays = config.overlays;
              })
              "${self.outPath}/hosts/${hostname}"
              inputs.lix-module.nixosModules.default
            ]
            ++ (lib.optionals (config.secrets != []) [
              inputs.agenix.nixosModules.default
              ({lib, ...}: let
                allSecrets = lib.mapAttrs' (name: value: {
                  name = lib.removeSuffix ".age" name;
                  inherit value;
                }) (import "${self.outPath}/secrets/secrets.nix");
                filteredSecrets =
                  lib.filterAttrs
                  (name: _: builtins.hasAttr name config.secrets)
                  allSecrets;
              in {
                age.secrets =
                  lib.mapAttrs' (name: _: {
                    name = builtins.baseNameOf name;
                    value = {
                      inherit (config.secrets.${name}) owner group file mode;
                    };
                  })
                  filteredSecrets;
              })
            ])
            ++ (lib.optionals config.enableHomeManager (let
              user = config.extraHmModulesUser;
              extraHmModules = config.extraHmModules;
            in [
              inputs.homeManager.nixosModule
              ({
                config,
                pkgs,
                ...
              }: {
                home-manager.users."${user}" = {
                  imports = extraHmModules;
                  _module.args = {
                    age = config.age or {};
                    fleetFlake = self;
                    pkgsStable = inputs.nixpkgsStable.legacyPackages.${pkgs.system};
                  };
                };
              })
            ]))
            ++ config.extraModules;
          specialArgs = {
            fleetModules = builtins.map (moduleName: "${self.outPath}/modules/${moduleName}");
            fleetHmModules = builtins.map (moduleName: "${self.outPath}/hmModules/${moduleName}");
            fleetFlake = self;
            vpn = cfg.vpnExtra // (lib.mapAttrs (_: host: host.vpn) cfg.hosts);
            inherit (flakePartsArgs.config.allSystems.${config.system}.allModuleArgs.config._module.args) inputs';
          };
        };
    };
    _mkDarwinConfiguration = lib.mkOption {
      description = "Function returning a proper Darwin configuration";
      type = lib.types.functionTo (lib.types.functionTo lib.types.attrs); # TODO improve this type
      internal = true;
      default = hostname: config:
        inputs.nixDarwin.lib.darwinSystem {
          modules = [
            ({
              lib,
              pkgs,
              ...
            }: {
              networking.hostName = lib.mkForce hostname;
              nixpkgs.overlays = config.overlays;
              nixpkgs.hostPlatform = config.system;
            })
            "${self.outPath}/hosts/${hostname}"
          ];
        };
    };

    _mkNixOnDroidConfiguration = lib.mkOption {
      description = "Function returning a proper nix-on-droid configuration";
      type = lib.types.functionTo (lib.types.functionTo lib.types.attrs); # TODO improve this type
      internal = true;
      default = hostname: config:
        inputs.nix-on-droid.lib.nixOnDroidConfiguration {
          modules = [
            ({
              lib,
              pkgs,
              ...
            }: {
              nixpkgs.overlays = config.overlays;
            })
            "${self.outPath}/hosts/${hostname}"
          ];
        };
    };
  };

  config = {
    flake.nixosConfigurations =
      lib.mapAttrs
      config.fleet._mkNixosConfiguration
      config.fleet.hosts;

    flake.darwinConfigurations =
      lib.mapAttrs
      config.fleet._mkDarwinConfiguration
      config.fleet.darwinHosts;

    flake.nixOnDroidConfigurations =
      lib.mapAttrs
      config.fleet._mkNixOnDroidConfiguration
      config.fleet.nixOnDroidHosts;
  };
}
