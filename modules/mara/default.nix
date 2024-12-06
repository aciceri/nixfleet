{
  config,
  lib,
  pkgs,
  fleetHmModules,
  fleetFlake,
  vpn,
  ...
}:
{
  options.mara = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };

    modules = lib.mkOption {
      type = with lib.types; listOf str;
      default = [
        "shell"
        "git"
      ];
    };

    packages = lib.mkOption {
      type = with lib.types; listOf package;
      default = [ ];
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
      default = "$6$znc6qUe/VpJFtoo4$1JWwDiykkqlUgXM2qfjyGoJT5J8kWKko83uMutB7eK1ApJToxawM8SSlksMUpJKJJ2DIPuJZZ7JIXN8U/Am8r."; # mkpasswd -m sha-512
    };

    extraGroups = lib.mkOption {
      type = with lib.types; listOf str;
      default = [
        "wheel"
        "fuse"
        "video"
        "dialout"
        "systemd-journal"
        "camera"
        "networkmanager"
      ];
    };
  };

  config = lib.mkIf config.mara.enable {

    programs.fish.enable = true;

    mara.modules = [
      "shell"
      "git"
      "nix-index"
      "btop"
    ];

    users.users.mara = {
      uid = 1001;
      inherit (config.mara) hashedPassword;
      description = "Mara Savastano";
      isNormalUser = true;
      inherit (config.mara) extraGroups;
      shell = pkgs.fish;
      openssh.authorizedKeys.keys = config.mara.authorizedKeys;
    };

    services.getty.autologinUser = if config.mara.autologin then "mara" else null;

    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.users.mara = {
      imports = fleetHmModules config.mara.modules ++ [
        {
          _module.args = {
            inherit (config.age) secrets;
            inherit vpn;
            username = "mara";
            hostname = config.networking.hostName;
          };
        }
      ];
      home.packages = config.mara.packages;
      home.stateVersion = config.system.stateVersion;
    };
  };
}
