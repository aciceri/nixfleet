{
  pkgs,
  secrets,
  ...
}: {
  programs.mbsync.enable = true;
  programs.msmtp.enable = true;
  programs.notmuch = {
    enable = true;
    hooks.preNew = "mbsync --all";
  };
  services.mbsync.enable = true;
  accounts.email = {
    accounts.autistici = {
      address = "andrea.ciceri@autistici.org";
      gpg = {
        key = "7A66EEA1E6C598D07D361287A1FC89532D1C565";
        signByDefault = true;
      };
      imap = {
        host = "mail.autistici.org";
        port = 993;
      };
      mbsync = {
        enable = true;
        create = "maildir";
      };
      msmtp.enable = true;
      notmuch.enable = true;
      primary = true;
      realName = "Andrea Ciceri";
      signature = {
        text = ''
          Andrea Ciceri
        '';
        showSignature = "append";
      };
      passwordCommand = "${pkgs.coreutils}/bin/cat ${secrets.autistici-password.path}";
      smtp = {
        host = "smtp.autistici.org";
      };
      userName = "andrea.ciceri@autistici.org";
    };
    accounts.mlabs = {
      address = "andreaciceri@mlabs.city";
      imap = {
        host = "imap.gmail.com";
        port = 993;
      };
      realName = "Andrea Ciceri";
      smtp.host = "smtp.gmail.com";
      userName = "andreaciceri@mlabs.city";
    };
  };
}
