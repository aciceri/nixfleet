{
  pkgs,
  lib,
  ...
}: {
  services.swayidle = let
    # Downgraded due to
    # https://github.com/mortie/swaylock-effects/issues/95
    swaylock-effects = pkgs.swaylock-effects.overrideAttrs (_: {
      version = "jirutka-master";
      src = pkgs.fetchFromGitHub {
        owner = "jirutka";
        repo = "swaylock-effects";
        rev = "a7691b86dabe5241c7292c7b8d0551d579ba1848";
        sha256 = "sha256-GN+cxzC11Dk1nN9wVWIyv+rCrg4yaHnCePRYS1c4JTk=";
      };
    });
    swaylockWithArgs = pkgs.writeScriptBin "swaylockWithArgs" ''
      ${swaylock-effects}/bin/swaylock \
        --daemonize \
        --screenshots \
        --clock \
        --indicator \
        --indicator-radius 100 \
        --indicator-thickness 7 \
        --effect-blur 7x5 \
        --effect-vignette 0.5:0.5 \
        --ring-color bb00cc \
        --key-hl-color 880033 \
        --line-color 00000000 \
        --inside-color 00000088 \
        --separator-color 00000000 \
        --grace 2 \
        --fade-in 0.2
    '';
    swaylockCommand = "${swaylockWithArgs}/bin/swaylockWithArgs";
  in {
    enable = true;
    events = [
      {
        event = "before-sleep";
        command = swaylockCommand;
      }
      {
        event = "lock";
        command = "lock";
      }
    ];
    timeouts = [
      {
        timeout = 600;
        command = swaylockCommand;
      }
    ];
  };

  # Otherwise it will start only after Sway and will not work with Hyprland
  systemd.user.services.swayidle.Unit.PartOf = lib.mkForce [];
}