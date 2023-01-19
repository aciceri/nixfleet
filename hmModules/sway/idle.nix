{pkgs, ...}: {
  services.swayidle = let
    # Downgraded due to
    # https://github.com/mortie/swaylock-effects/issues/95
    swaylock-effects = pkgs.swaylock-effects.overrideAttrs (_: {
      version = "1.6-3";
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
}
