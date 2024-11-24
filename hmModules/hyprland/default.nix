{
  config,
  pkgs,
  ...
}:
let
  screenshotScript = pkgs.writeShellScriptBin "screenshot.sh" ''
    filename="$HOME/shots/$(date --iso-8601=seconds).png"
    coords="$(${pkgs.slurp}/bin/slurp)"
    ${pkgs.grim}/bin/grim -t png -g "$coords" "$filename"
    wl-copy -t image/png < $filename
  '';
  hyprland = config.wayland.windowManager.hyprland.package;
  switchMonitorScript = pkgs.writeShellScriptBin "switch-monitor.sh" ''
    if [[ "$(${hyprland}/bin/hyprctl monitors) | grep '\sDP-[0-9]+'" ]]; then
      if [[ $1 == "open" ]]; then
        ${hyprland}/bin/hyprctl keyword monitor "eDP-1,1920x1080,3760x230,1"
      else
        ${hyprland}/bin/hyprctl keyword monitor "eDP-1,disable"
      fi
    fi
  '';
in
{
  imports = [
    ./hyprpaper.nix
    ../waybar
    ../swayidle
    ../gammastep
    ../swaync
    ../foot
  ];

  home.packages = with pkgs; [
    wl-clipboard
    waypipe
    switchMonitorScript
    screenshotScript
    hyprpaper
    fuzzel
    brightnessctl
  ];

  systemd.user.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  services.network-manager-applet.enable = true;
  services.blueman-applet.enable = true;
  services.pasystray.enable = true;
  xsession.enable = true;

  services.udiskie.enable = true;

  gtk = {
    enable = true;
    # font.name = lib.mkForce "Sans,Symbols Nerd Font";
    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
    cursorTheme = {
      name = "catppuccin-mocha-sapphire";
      package = pkgs.catppuccin-cursors;
      size = 40;
    };
  };

  qt = {
    enable = true;
  };

  home.file.".icons/catppuccin-mocha-sapphire" = {
    source = "${pkgs.catppuccin-cursors.mochaSapphire}/share/icons/catppuccin-mocha-sapphire-cursors";
    recursive = true;
  };

  wayland.windowManager.hyprland = {
    enable = true;
    plugins = with pkgs.hyprlandPlugins; [
      hy3
      hyprspace
    ];
    # TODO migrate to structured options
    extraConfig = builtins.readFile ./hyprland.conf;
  };
}
