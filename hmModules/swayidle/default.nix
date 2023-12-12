{
  pkgs,
  lib,
  ...
}: {
  services.swayidle = let
    # Downgraded due to
    # https://github.com/mortie/swaylock-effects/issues/95
    # swaylock-effects = pkgs.swaylock-effects.overrideAttrs (_: {
    #   version = "jirutka-master";
    #   src = pkgs.fetchFromGitHub {
    #     owner = "jirutka";
    #     repo = "swaylock-effects";
    #     rev = "7c5681ce96587ce3090c6698501faeccdfdc157d";
    #     sha256 = "sha256-09Kq90wIIF9lPjiY2anf9MSgi/EqeXKXW1mFmhxA/aM";
    #   };
    # });
    swaylockWithArgs = pkgs.writeScriptBin "swaylockWithArgs" ''
      ${pkgs.swaylock-effects}/bin/swaylock \
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
        command = swaylockCommand;
      }
    ];
    timeouts = [
      {
        timeout = 600;
        command = swaylockCommand;
      }
      {
        timeout = 720;
        command = "${pkgs.systemd}/bin/systemctl suspend";
      }
    ];
  };

  # Otherwise it will start only after Sway and will not work with Hyprland
  systemd.user.services.swayidle = {
    Unit.PartOf = lib.mkForce [];
    Install.WantedBy = lib.mkForce ["hyprland-session.target"];
  };
}
