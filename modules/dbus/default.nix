{pkgs, ...}: {
  services.dbus.packages = [pkgs.dconf];
  programs.dconf.enable = true;
}
