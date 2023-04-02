{
  config,
  lib,
  pkgs,
  fleetHmModules,
  fleetFlake,
  ...
}: {
  options.ccr = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };

    modules = lib.mkOption {
      type = with lib.types; listOf str;
      default = ["shell" "git" "nix-index"];
    };

    packages = lib.mkOption {
      type = with lib.types; listOf package;
      default = [];
    };

    autologin = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };

    authorizedKeys = lib.mkOption {
      type = with lib.types; listOf str;
      default = builtins.attrValues (import "${fleetFlake}/lib").keys.users;
    };

    hashedPassword = lib.mkOption {
      type = lib.types.str;
      default = "$6$JGOefuRk7kL$fK9.5DFnLLoW08GL4eKRyf958jyZdw//hLMaz4pp28jJuSFb24H6R3dgt1.sMs0huPY85rludSw4dnQJG5xSw1"; # mkpasswd -m sha-512
    };

    extraGroups = lib.mkOption {
      type = with lib.types; listOf str;
      default = ["wheel" "fuse" "networkmanager" "dialout"];
    };
  };

  config = lib.mkIf config.ccr.enable {
    users.users.ccr = {
      uid = 1000;
      inherit (config.ccr) hashedPassword;
      description = "Andrea Ciceri";
      isNormalUser = true;
      inherit (config.ccr) extraGroups;
      shell = pkgs.nushell;
      openssh.authorizedKeys.keys = config.ccr.authorizedKeys;
    };

    services.getty.autologinUser =
      if config.ccr.autologin
      then "ccr"
      else null;

    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.users.ccr = {
      imports =
        fleetHmModules config.ccr.modules
        ++ [
          {
            _module.args = {
              inherit (config.age) secrets;
            };
          }
        ];
      home.packages = config.ccr.packages;
      home.stateVersion = config.system.stateVersion;
    };
  };
}
