{
  pkgs,
  lib,
  ...
}:
{
  services.gnome-keyring = {
    enable = false; # Is this broken? https://github.com/nix-community/home-manager/issues/1454
    components = lib.mkForce [
      "secrets"
      "ssh"
    ];
  };

  home.packages = [ pkgs.gcr ]; # Needed in PATH

  # Workaround
  wayland.windowManager.hyprland.extraConfig = ''
    exec-once = ${pkgs.gnome.gnome-keyring}/bin/gnome-keyring-daemon --start --foreground --components=secrets,ssh,pkcs
  '';
}
