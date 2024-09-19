{lib, ...}: {
  services.pipewire.enable = true;

  hardware.pulseaudio = {
    enable = lib.mkForce false;
  };
}
