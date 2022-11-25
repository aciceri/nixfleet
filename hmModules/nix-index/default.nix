{
  config,
  pkgs,
  ...
}: {
  systemd.user.services.nix-index-update = {
    Unit = {Description = "Update nix-index";};

    Service = {
      CPUSchedulingPolicy = "idle";
      IOSchedulingClass = "idle";
      ExecStart = "${pkgs.nix-index}/bin/nix-index --path ${config.programs.password-store.settings.PASSWORD_STORE_DIR}";
    };
  };

  systemd.user.timers.nix-index-update = {
    Unit = {Description = "Update nix-index";};

    Timer = {
      Unit = "nix-index-update.service";
      OnCalendar = "OnCalendar=monday  *-*-* 10:00:00";
      Persistent = true;
    };

    Install = {WantedBy = ["timers.target"];};
  };
}
