{
  config,
  lib,
  pkgs,
  fleetHmModules,
  fleetFlake,
  vpn,
  options,
  ...
}:
let
  cfg = config.ccr;
  inherit (lib) types;
in
{
  options.ccr = {
    enable = lib.mkEnableOption "ccr";

    username = lib.mkOption {
      type = types.str;
      default = "ccr";
    };

    description = lib.mkOption {
      type = types.str;
      default = "Andrea Ciceri";
    };

    shell = lib.mkOption {
      type = lib.types.package;
      default = pkgs.bash;
    };

    modules = lib.mkOption {
      type = types.listOf types.str;
      default = [ ];
    };

    packages = lib.mkOption {
      type = types.listOf types.package;
      default = [ ];
    };

    autologin = lib.mkOption {
      type = types.bool;
      default = false;
    };

    authorizedKeys = lib.mkOption {
      type = types.listOf types.str;
      default = builtins.attrValues (import "${fleetFlake}/lib").keys.users;
    };

    hashedPassword = lib.mkOption {
      type = types.str;
      default = "$6$JGOefuRk7kL$fK9.5DFnLLoW08GL4eKRyf958jyZdw//hLMaz4pp28jJuSFb24H6R3dgt1.sMs0huPY85rludSw4dnQJG5xSw1"; # mkpasswd -m sha-512
    };

    extraGroups = lib.mkOption {
      type = types.listOf types.str;
      default = { };
    };

    extraModules = lib.mkOption {
      type = types.listOf types.deferredModule;
      default = [ ];
    };

    backupPaths = lib.mkOption {
      type = types.listOf types.str;
      default = [ ];
    };

    impermanence = {
      enable = lib.mkOption {
        type = types.bool;
        default = (config.environment.persistence or null) != null;
      };

      directories = lib.mkOption {
        type = types.listOf types.anything; # TODO re-use type from the NixOS module
        default = [
          ".cache"
          "Downloads"
        ];
      };

      files = lib.mkOption {
        type = types.listOf types.anything; # TODO re-use type from the NixOS module
        default = [
          ".ssh/id_ed25519.pub"
          ".ssh/id_ed25519"
          ".ssh/authorized_keys"
          ".ssh/known_hosts"
        ];
      };
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      (lib.optionalAttrs (builtins.hasAttr "backup" options) {
        backup.paths = cfg.backupPaths;
      })
      {
        # FIXME shouldn't set these groups by default
        ccr.extraGroups = [
          "wheel"
          "fuse"
          "video"
          "dialout"
          "systemd-journal"
          "camera"
          "networkmanager"
        ];
        ccr.modules = [
          "shell"
          "git"
          "nix-index"
          "btop"
        ];

        users.users.${cfg.username} = {
          inherit (config.ccr) hashedPassword extraGroups description;
          uid = 1000;
          isNormalUser = true;
          shell = cfg.shell;
          openssh.authorizedKeys.keys = config.ccr.authorizedKeys;
        };

        services.getty.autologinUser = if config.ccr.autologin then cfg.username else null;

        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.${cfg.username} = {
          imports =
            fleetHmModules cfg.modules
            ++ [
              {
                _module.args = {
                  inherit (config.age) secrets;
                  inherit (cfg) username;
                  inherit vpn;
                  hostname = config.networking.hostName;
                };
              }
            ]
            ++ [
              (lib.optionalAttrs cfg.impermanence.enable {
                home.persistence."/persist/home/${cfg.username}" = {
                  inherit (cfg.impermanence) directories files;
                  allowOther = true;
                };
              })
            ]
            ++ cfg.extraModules;
          home.packages = cfg.packages;
          home.stateVersion = config.system.stateVersion;
        };
      }
      (lib.mkIf cfg.impermanence.enable {
        programs.fuse.userAllowOther = true;
      })
    ]
  );
}
