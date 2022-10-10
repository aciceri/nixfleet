{
  config,
  lib,
  pkgs,
  fleetHmModules,
  ...
}: {
  options.mara = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };

    modules = lib.mkOption {
      type = with lib.types; listOf str;
      default = ["shell" "git"];
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
      ];
    };

    hashedPassword = lib.mkOption {
      type = lib.types.str;
      default = "$6$znc6qUe/VpJFtoo4$1JWwDiykkqlUgXM2qfjyGoJT5J8kWKko83uMutB7eK1ApJToxawM8SSlksMUpJKJJ2DIPuJZZ7JIXN8U/Am8r."; # mkpasswd -m sha-512
    };

    extraGroups = lib.mkOption {
      type = with lib.types; listOf str;
      default = ["wheel" "fuse" "networkmanager" "dialout"];
    };
  };

  config = lib.mkIf config.mara.enable {
    users.users.mara = {
      uid = 1001;
      hashedPassword = config.mara.hashedPassword;
      description = "Mara Savastano";
      isNormalUser = true;
      extraGroups = config.mara.extraGroups;
      shell = pkgs.zsh;
      openssh.authorizedKeys.keys = config.mara.authorizedKeys;
    };

    services.getty.autologinUser =
      if config.mara.autologin
      then "mara"
      else null;

    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.users.mara = {
      imports = fleetHmModules config.mara.modules;
      home.packages = config.mara.packages;
      home.stateVersion = config.system.stateVersion;
    };
  };
}
