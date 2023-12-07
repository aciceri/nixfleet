{pkgs, ...}: {
  services.blueman.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.bluetooth.enable = true;
  services.dbus.packages = with pkgs; [blueman];
  ccr.extraGroups = ["bluetooth"];
}
