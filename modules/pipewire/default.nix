{ lib, ... }:
{
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    jack.enable = true;
  };

  services.pulseaudio = {
    enable = false;
  };
}
