{
  pkgs,
  lib,
  fleetFlake,
  ...
}: {
  programs.waybar = {
    # package = fleetFlake.packages.${pkgs.system}.waybar-hyprland;
    enable = true;
    systemd = {
      enable = true;
    };
    style = builtins.readFile ./style.css;
    settings = {
      mainBar = {
        ipc = true;
        layer = "top";
        position = "top";
        height = 30;

        modules-left = [
          "wlr/mode"
          "hyprland/workspaces"
        ];
        modules-center = ["wlr/window"];
        modules-right = [
          "network"
          "tray"
          "pulseaudio"
          "cpu"
          "memory"
          "temperature"
          "battery"
          "clock"
        ];

        "hyprland/workspaces" = {
          all-outputs = true;
          disable-scroll-wraparound = true;
          # format = "{icon}";
          on-click = "activate";
          # format-icons = {
          #   "1" = "";
          #   "2" = "";
          #   "3" = "";
          #   "9" = "ﬧ";
          #   urgent = "";
          # };
          # sort-by-number = true;
        };

        "wlr/mode" = {tooltip = false;};

        "wlr/window" = {max_length = 50;};
        tray = {
          spacing = 10;
        };
        battery = {
          format = "{capacity}% {icon}";
          format-alt = "{time} {icon}";
          format-charging = "{capacity}% ";
          format-icons = [" " " " " " " " " "];
          format-plugged = "{capacity}%  ";
          states = {
            critical = 15;
            warning = 30;
          };
        };
        clock = {
          format-alt = "{:%Y-%m-%d}";
          tooltip-format = "{:%Y-%m-%d | %H:%M}";
        };
        cpu = {
          format = "{usage}% ";
          tooltip = false;
        };
        memory = {format = "{}% ";};
        network = {
          interval = 1;
          format-alt = "{ifname}: {ipaddr}/{cidr}";
          format-disconnected = "Disconnected ⚠";
          format-ethernet = "{ifname}: {ipaddr}/{cidr} 󰈀  up: {bandwidthUpBits} down: {bandwidthDownBits}";
          format-linked = "{ifname} (No IP) ";
          format-wifi = "{essid} ({signalStrength}%)   {ipaddr}/{cidr} up: {bandwidthUpBits} down: {bandwidthDownBits}";
        };
        pulseaudio = {
          format = "{volume}% {icon} {format_source}";
          format-bluetooth = "{volume}% {icon} {format_source}";
          format-bluetooth-muted = " {icon} {format_source}";
          format-icons = {
            car = "";
            default = [" " " " " "];
            handsfree = "";
            headphones = " ";
            headset = "";
            phone = "";
            portable = "";
          };
          format-muted = " {format_source}";
          format-source = "{volume}% ";
          format-source-muted = "";
          on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
        };
        "wlr/mode" = {format = ''<span style="italic">{}</span>'';};
        temperature = {
          critical-threshold = 80;
          format = "{temperatureC}°C {icon}";
          format-icons = ["" "" ""];
          hwmon-path = "/sys/class/thermal/thermal_zone4/temp";
        };
      };
    };
  };

  # waybar needs the hyprctl binary in PATH when started in hyprland
  systemd.user.services.waybar.Service.Environment = "PATH=${lib.makeBinPath [pkgs.hyprland]}";
}
