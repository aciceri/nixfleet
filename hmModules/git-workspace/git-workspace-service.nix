{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.git-workspace;
  tomlFormat = pkgs.formats.toml {};
in {
  options.services.git-workspace = {
    enable = lib.mkEnableOption "git-workspace systemd timer";
    package = lib.mkOption {
      type = lib.types.package;
      default =
        if config.programs.git-workspace.enable
        then config.programs.git-workspace.package
        else pkgs.git-workspace;
      description = "The git-workspace to use";
    };
    frequency = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "";
    };
    environmentFile = lib.mkOption {
      type = lib.types.path;
      default = "";
      description = "";
      example = "";
    };
    workspaces = lib.mkOption {
      type = lib.types.attrsOf tomlFormat.type;
      default = {};
      description = "Workspaces verbatims";
      # example = {
      #   workspace-foo = {
      #     provider = [
      #       {
      #         provider = "github";
      #         name = "";
      #         path = "...";
      #         skip_forks = false;
      #       }
      #     ];
      #   };
      # };
    };
  };
  config = lib.mkIf cfg.enable {
    xdg.configFile =
      lib.mapAttrs' (workspaceName: workspace: {
        name = "git-workspace/${workspaceName}/workspace.toml";
        value.source =
          (tomlFormat.generate "${workspaceName}-workspace.toml" workspace).outPath;
      })
      cfg.workspaces;
    systemd.user.services =
      lib.mapAttrs' (workspaceName: workspace: rec {
        name = "git-workspace-${workspaceName}-update";
        value = {
          Unit.Description = "Runs `git-workspace update` for ${workspaceName}";
          Service = {
            EnvironmentFile = cfg.environmentFile;
            ExecStart = let
              script = pkgs.writeShellApplication {
                name = "${name}-launcher";
                text = ''
                  ${cfg.package}/bin/git-workspace \
                    --workspace ${config.xdg.configHome}/git-workspace/${workspaceName} \
                    update
                '';
                runtimeInputs = with pkgs; [busybox openssh git];
              };
            in "${script}/bin/${name}-launcher";
          };
        };
      })
      cfg.workspaces;
    systemd.user.timers =
      lib.mapAttrs' (workspaceName: workspace: {
        name = "git-workspace-${workspaceName}-update";
        value = {
          Unit = {
            Description = "Automatically runs `git-workspace update` for ${workspaceName}";
          };
          Timer = {
            Unit = "git-workspace-${workspaceName}-update.unit";
            OnCalendar = cfg.frequency;
            Persistent = true;
          };
          Install.WantedBy = ["timers.target"];
        };
      })
      cfg.workspaces;
  };
}
