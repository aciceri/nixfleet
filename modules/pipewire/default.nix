{ lib, ... }:
{
  services.pipewire.enable = true;

  hardware.pulseaudio = {
    enable = false;
  };
}
