{
  pkgs,
  lib,
  ...
}:
{
  programs.waybar = {
    enable = true;
    systemd.enable = true;
  };

  catppuccin.waybar.enable = lib.mkForce false;

  home.activation.linkWaybarConfig = lib.hm.dag.entryAnywhere ''
    if [ ! -d "$HOME/.config/waybar" ]; then
      $DRY_RUN_CMD mkdir -p "$HOME/.config/waybar"
      $DRY_RUN_CMD ln -s "$HOME/projects/aciceri/nixfleet/hmModules/waybar/config.json" "$HOME/.config/waybar/config"
      $DRY_RUN_CMD ln -s "$HOME/projects/aciceri/nixfleet/hmModules/waybar/style.css" "$HOME/.config/waybar/style.css"
    fi
  '';

  home.packages = with pkgs; [
    rofi-power-menu
  ];
}
