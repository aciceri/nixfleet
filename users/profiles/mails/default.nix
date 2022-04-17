{ pkgs, lib, ... }:
let
  maildir = "mail";
in
{
  programs.msmtp.enable = true; # For sending emails

  # For fetching emails
  accounts.email.maildirBasePath = maildir;
  programs.mbsync = {
    enable = true;
  };

  # For email browsing, tagging, and searching
  programs.notmuch.enable = true;

  accounts.email.accounts = {
    personal = {
      realName = "Andrea Ciceri";
      address = "andrea.ciceri@autistici.org";
      primary = true;
      flavor = "plain";
      passwordCommand = "pass show autistici/password";
      #gpg = {
      #  key = "";
      #  signByDefault = true;
      #};
      imap =
        {
          host = "mail.autistici.org";
          port = 993;
          tls.enable = true;
        };
      mbsync = {
        enable = true;
        create = "maildir";
        expunge = "both";
      };
      msmtp.enable = true;
      notmuch.enable = true;
      #signature = {
      #  text = ''
      #  '';
      #  showSignature = "append";
      #};
      smtp = {
        host = "smtp.autistici.org";
        port = 465;
        tls.enable = true;
      };
      userName = "andrea.ciceri@autistici.org";
    };
  };

  systemd.user =
    let
      description = "Download mailboxes with mbsync and update notmuch db";
    in
    {
      services.mbsync-and-notmuch =
        {
          Unit = {
            After = [ "network.target" ];
            Description = description;
          };
          Service = {
            Type = "simple";
            ExecStart = ''${pkgs.isync}/bin/mbsync -Va && ${pkgs.notmuch}/bin/notmuch new'';
          };
          Install = {
            WantedBy = [ "multi-user.target" ];
          };
        };
      timers.mbsync-and-notmuch = {
        Unit = {
          Description = "Timer to \"${description}\"";
        };
        Timer = {
          OnBootSec = "2m";
          OnUnitInactiveSec = "5m";
        };
        Install = {
          WantedBy = [ "timers.target" ];
        };
      };
    };
}
