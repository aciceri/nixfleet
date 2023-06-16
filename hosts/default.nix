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
          colmena = lib.mkOption {
            description = "Set colmena.<host>";
            type = lib.types.attrs;
            default = {};
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
        config.overlays = with inputs; [
          agenix.overlays.default
          comma.overlays.default
          helix.overlays.default
          nur.overlay
        ];
      }));
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
                networking.hosts =
                  lib.mapAttrs' (hostname: ip: {
                    name = ip;
                    value = ["${hostname}.fleet"];
                  })
                  (import "${self}/lib").ips;
              })
              "${self.outPath}/hosts/${hostname}"
            ]
            ++ (lib.optionals (config.secrets != []) [
              inputs.agenix.nixosModules.default
              ({lib, ...}: let
                allSecrets = lib.mapAttrs' (name: value: {
                  name = lib.removeSuffix ".age" name;
                  inherit value;
                }) (import "${self.outPath}/secrets");
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
              ({config, ...}: {
                home-manager.users."${user}" = {
                  imports = extraHmModules;
                  _module.args.age = config.age or {};
                };
              })
            ]))
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
      thinkpad = {
        extraModules = with inputs; [
          nixosHardware.nixosModules.lenovo-thinkpad-x1-7th-gen
          hyprland.nixosModules.default
        ];
        extraHmModules = with inputs; [
          ccrEmacs.hmModules.default
          hyprland.homeManagerModules.default
        ];
        overlays = [inputs.nil.overlays.default];
        secrets = {
          "thinkpad-wireguard-private-key" = {};
          "cachix-personal-token".owner = "ccr";
          "autistici-password".owner = "ccr";
        };
      };
      rock5b = {
        system = "aarch64-linux";
        extraModules = with inputs; [
          disko.nixosModules.disko
          rock5b.nixosModules.default
        ];
        secrets = {
          "rock5b-wireguard-private-key" = {};
        };
        colmena.deployment.buildOnTarget = true;
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
        secrets = {
          "pbp-wireguard-private-key" = {};
        };
      };
      hs = {};
      mothership = {
        extraModules = with inputs; [
          disko.nixosModules.disko
          nix-serve-ng.nixosModules.default
          hydra.nixosModules.hydra
        ];
        extraHmModules = [
          inputs.ccrEmacs.hmModules.default
          {
            # TODO: remove after https://github.com/nix-community/home-manager/pull/3811
            imports = let
              hmModules = "${inputs.homeManagerGitWorkspace}/modules";
            in [
              "${hmModules}/programs/git-workspace.nix"
              "${hmModules}/services/git-workspace.nix"
            ];
          }
        ];
        overlays = [inputs.nil.overlays.default];
        secrets = {
          "mothership-wireguard-private-key" = {};
          "cachix-personal-token".owner = "ccr";
          "git-workspace-tokens".owner = "ccr";
          "magit-forge-github-token".owner = "ccr";
          "hydra-admin-password".owner = "root";
          "hydra-github-token".group = "hydra";
          "cache-private-key".owner = "nix-serve";
        };
      };
    };

    flake.nixosConfigurations =
      lib.mapAttrs
      config.fleet._mkNixosConfiguration
      config.fleet.hosts;

    flake.colmena =
      {
        meta = {
          nixpkgs = inputs.nixpkgsUnstable.legacyPackages.x86_64-linux;
          nodeNixpkgs = builtins.mapAttrs (name: value: value.pkgs) self.nixosConfigurations;
          nodeSpecialArgs = builtins.mapAttrs (name: value: value._module.specialArgs) self.nixosConfigurations;
        };
      }
      // builtins.mapAttrs (name: host:
        lib.recursiveUpdate {
          imports = self.nixosConfigurations.${name}._module.args.modules;
          deployment.targetHost = "${name}.fleet";
        }
        host.colmena)
      config.fleet.hosts;
  };
}
