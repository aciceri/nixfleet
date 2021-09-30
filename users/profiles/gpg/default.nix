{ pkgs, ... }:
{
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    sshKeys = [ "CE2FD0D9BECBD8876811714925066CC257413416" ];
    extraConfig = ''
      pinentry-program ${pkgs.pinentry-gtk2}/bin/pinentry-gtk-2
    '';
  };

  programs.gpg = {
    enable = true;
    settings = {};
  };
}
