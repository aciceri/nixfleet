{pkgs, ...}: {
  programs.waybar = {
    enable = true;
    style = builtins.readFile ./style.css;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;

        modules-left = [
          "sway/mode"
          "sway/workspaces"
        ];
        modules-center = ["sway/window"];
        modules-right = [
          "tray"
          "network"
          "cpu"
          "memory"
          "pulseaudio"
          "clock"
          "backlight"
          "battery"
        ];

        "sway/workspaces" = {
          all-outputs = true;
          disable-scroll-wraparound = true;
        };

        "sway/mode" = {tooltip = false;};

        "sway/window" = {max_length = 50;};

        pulseaudio = {
          format = "vol {volume}%";
          on-click-middle = "${pkgs.sway}/bin/swaymsg exec \"${pkgs.pavucontrol}/bin/pavucontrol\"";
        };

        network = {
          format-wifi = "{essid} {signalStrength}% {bandwidthUpBits} {bandwidthDownBits}";
          format-ethernet = "{ifname} eth {bandwidthUpBits} {bandwidthDownBits}";
        };

        cpu = {
          interval = 2;
          format = "{icon} {usage}";
        };

        memory.format = "mem {}%";

        backlight = {
          format = "nit {percent}%";
          on-scroll-up = "${pkgs.brightnessctl}/bin/brightnessctl s +5%";
          on-scroll-down = "${pkgs.brightnessctl}/bin/brightnessctl s 5%-";
        };

        tray.spacing = 10;

        clock.format = "{:%a %b %d %H:%M}";

        battery = {
          format = "bat {}";
        };
      };
    };
  };
}
