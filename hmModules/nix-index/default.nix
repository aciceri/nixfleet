{
  config,
  pkgs,
  fleetFlake,
  lib,
  ...
}: {
  programs.nix-index.enable = true;

  systemd.user.services.nix-index-update = {
    Unit = {Description = "Update nix-index";};

    Service = {
      CPUSchedulingPolicy = "idle";
      IOSchedulingClass = "idle";
      ExecStart = "${pkgs.nix-index}/bin/nix-index --nixpkgs ${fleetFlake.inputs.nixpkgsUnstable}";
    };
  };

  systemd.user.timers.nix-index-update = {
    Unit = {Description = "Update nix-index";};

    Timer = {
      Unit = "nix-index-update.service";
      OnCalendar = "monday  *-*-* 10:00:00";
      Persistent = true;
    };

    Install = {WantedBy = ["timers.target"];};
  };
}
