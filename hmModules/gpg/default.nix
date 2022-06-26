{pkgs, ...}: {
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    sshKeys = ["CE2FD0D9BECBD8876811714925066CC257413416"];
    extraConfig = ''
      allow-emacs-pinentry
      allow-loopback-pinentry
    '';
  };

  programs.gpg = {
    enable = true;
    settings = {};
  };
}
