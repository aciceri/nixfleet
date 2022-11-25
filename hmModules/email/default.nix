{
  pkgs,
  secrets,
  ...
}: {
  home.packages = with pkgs; [mu];
  programs.mbsync.enable = true;
  programs.msmtp.enable = true;
  programs.notmuch = {
    enable = true;
    hooks = {
      preNew = "mbsync --all";
    };
  };
  services = {
    mbsync = {
      enable = true;
      frequency = "*:0/15";
      preExec = "${pkgs.isync}/bin/mbsync -Ha";
      # First time run: mu init --maildir ~/.mail --my-address andrea.ciceri@autistici.org
      # TODO Nixify this
      postExec = "${pkgs.mu}/bin/mu index";
    };
  };
  accounts.email = {
    maildirBasePath = ".mail";
    accounts.autistici = {
      address = "andrea.ciceri@autistici.org";
      gpg = {
        key = "7A66EEA1E6C598D07D361287A1FC89532D1C565";
        signByDefault = true;
      };
      imap.host = "mail.autistici.org";
      mbsync = {
        enable = true;
        create = "maildir";
      };
      msmtp.enable = true;
      notmuch.enable = true;
      primary = true;
      realName = "Andrea Ciceri";
      signature = {
        # text = '''';
        showSignature = "append";
      };
      passwordCommand = "${pkgs.pass}/bin/pass show autistici/password";
      smtp = {
        host = "smtp.autistici.org";
      };
      userName = "andrea.ciceri@autistici.org";
    };
  };
}
