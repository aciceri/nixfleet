{pkgs, ...}: {
  services.teamviewer.enable = true;
  ccr.packages = [pkgs.teamviewer];
}
