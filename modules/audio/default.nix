{pkgs, ...}: {
  sound.enable = true;

  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
  };

  users.extraUsers.ccr.extraGroups = ["audio"];
}
