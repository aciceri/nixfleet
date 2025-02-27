{ lib, ... }:
{
  services.pipewire.enable = true;

  services.pulseaudio = {
    enable = false;
  };
}
