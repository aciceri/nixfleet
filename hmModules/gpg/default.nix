{ pkgs, ... }:
{
  services.gpg-agent = {
    enable = true;
    pinentry.package = pkgs.pinentry-rofi.override {
      rofi = pkgs.rofi-wayland;
    };
    extraConfig = ''
      allow-emacs-pinentry
      allow-loopback-pinentry
    '';
  };

  programs.gpg = {
    enable = true;
    settings = { };
  };
}
