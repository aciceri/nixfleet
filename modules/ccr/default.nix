{
  config,
  lib,
  pkgs,
  fleetHmModules,
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
      default = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDJmn7H6wxrxCHypvY74Z6pBr5G6v564NaUZb9xIILV92JEdpZzuTLLlP+JkMx/8MLRy+pC7prMwR+FhH+LaTm/9x3T6FYP/q9UIAL3cFwBAwj5XQXQKzx9f6pX/7iJrMfAUQ+ZrRUNJHt5Gl+8UypmDgnQLuv5vmQSMRzKnUPuu4lCJtWOpSPhXffz3Ec1tm5nAMuxIMRPY91PYu1fMLlFrjB1FX1goVHKB1uWx16GjJszYCVbN6xcPac0sgUg+qNGBhWkUh0F073rhepQJeWp5FtwIxe2zRsZBxxTy5qxNLmHzBeNDxlOkcy2/Lr+BxVy+mhF/2fJziX80/bWSEA1"
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDynKeHTnXOTCi+MH2agM4k5uBkTL+W5xkL/ep3DKuTIb9MbKjHkRIquSdVRAit4ZQVQN+S3yoCXCRdLLurM3/a6C7vc/a3UfGPyV/oDYDCdHNsOwimqIQg8Pc0WtnevLpZTC2VR4UU8zzaD/mmEWqxNszaNNUve+Fy0lwg6jn6vTnQCupbyMnghherozPJu94H/JLuDEcPT0wZUmBjhjT+yHp65Yk8hKVb1jRqEdjAHM4yZf6ceIxI9NMGeSnAKf/b8IsO6y7A93NZ75CnD6AW9Rclemi+nOqZo9zQ2m2LRtMTHSoNOLLkNQCCD+l2G4w1wPMONw4mz1vR917iJdd+5BXDtEVwScDfOmqVewynxkfztSvB+qTDzdqde3NO8fFA8jMk3rUXXfIl/Yb0G87wVT/Jcl7+ZBch8s+ljPsmyy5RY+uXLgKgE1tne0KJuzeJtxSAzTrPUhILB/A8PuJUzVGVWAdGRcusOc/0SdsluFsa11E0D946JcgNo72bWm0="
      ];
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
      shell = pkgs.zsh;
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
