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
                      inherit (config.secrets.${name}) owner group file;
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
        extraModules = [inputs.nixosHardware.nixosModules.lenovo-thinkpad-x1-7th-gen];
        extraHmModules = [
          inputs.ccrEmacs.hmModules.default
        ];
        secrets = {
          "thinkpad-wireguard-private-key" = {};
          "cachix-personal-token".owner = "ccr";
        };
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
      hs = {};
      mothership = {
        extraModules = [inputs.disko.nixosModules.disko];
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
        secrets = {
          "mothership-wireguard-private-key" = {};
          "cachix-personal-token".owner = "ccr";
          "git-workspace-tokens".owner = "ccr";
          "magit-forge-github-token".owner = "ccr";
        };
      };
    };

    flake.nixosConfigurations =
      lib.mapAttrs
      config.fleet._mkNixosConfiguration
      config.fleet.hosts;
  };
}
