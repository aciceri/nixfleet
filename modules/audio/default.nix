{pkgs, ...}: {
  sound.enable = true;

  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
  };
}
