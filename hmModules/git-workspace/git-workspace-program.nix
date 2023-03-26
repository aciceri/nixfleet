{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.git-workspace;
in {
  options.programs.git-workspace = {
    enable = lib.mkEnableOption "git-workspace";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.git-workspace;
      description = "The git-workspace to use";
    };
  };
  config = lib.mkIf cfg.enable {
    home.packages = [pkgs.git-workspace];
  };
}
