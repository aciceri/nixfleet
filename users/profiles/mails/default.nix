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
      address = "andrea.ciceri@autistici.org";
      #gpg = {
      #  key = "";
      #  signByDefault = true;
      #};
      imap.host = "mail.autistici.org";
      mbsync = {
        enable = true;
        create = "maildir";
      };
      msmtp.enable = true;
      notmuch.enable = true;
      primary = true;
      realName = "Andrea Ciceri";
      #signature = {
      #  text = ''
      #  '';
      #  showSignature = "append";
      #};
      passwordCommand = "pass show autistici/password";
      smtp = {
        host = "smtp.autistici.org";
      };
      userName = "andrea.ciceri@autistici.org";
    };
  };
}
