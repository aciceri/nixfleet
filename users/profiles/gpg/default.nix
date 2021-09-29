{
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    sshKeys = [ "CE2FD0D9BECBD8876811714925066CC257413416" ];
  };

  programs.gpg = {
    enable = true;
    settings = { };
  };
}
