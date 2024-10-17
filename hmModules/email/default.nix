{
  pkgs,
  secrets,
  fleetFlake,
  lib,
  ...
}:
{
  programs.mbsync.enable = true;
  programs.msmtp.enable = true;
  services.mbsync = {
    enable = true;
    postExec = lib.getExe (
      pkgs.writeShellScriptBin "mbsync-post-exec" ''
              ${lib.getExe pkgs.notmuch} new
              for _ in _ _
              do
        	afew -C ~/.config/notmuch/default/config --tag --new -vv
        	afew -C ~/.config/notmuch/default/config --move --new -vv
              done
      ''
    );
  };

  home.file.".config/aerc/stylesets" =
    let
      catppuccin-aerc = pkgs.fetchFromGitHub {
        owner = "catppuccin";
        repo = "aerc";
        rev = "ca404a9f2d125ef12db40db663d43c9d94116a05";
        hash = "sha256-OWIkHsKFts/zkrDUtbBPXHVSrHL/F0v3LB1rnlFAKmE=";
      };
    in
    {
      source = "${catppuccin-aerc}/dist";
      recursive = true;
    };

  programs.aerc = {
    enable = true;
    extraBinds = {
      global = {
        "<C-p>" = ":prev-tab<Enter>";
        "<C-n>" = ":next-tab<Enter>";
        "?" = ":help keys<Enter>";
      };

      messages = {
        "h" = ":prev-tab<Enter>";
        "l" = ":next-tab<Enter>";

        "j" = ":next<Enter>";
        "<Down>" = ":next<Enter>";
        "<C-d>" = ":next 50%<Enter>";
        "<C-f>" = ":next 100%<Enter>";
        "<PgDn>" = ":next 100%<Enter>";

        "k" = ":prev<Enter>";
        "<Up>" = ":prev<Enter>";
        "<C-u>" = ":prev 50%<Enter>";
        "<C-b>" = ":prev 100%<Enter>";
        "<PgUp>" = ":prev 100%<Enter>";
        "g" = ":select 0<Enter>";
        "G" = ":select -1<Enter>";

        "J" = ":next-folder<Enter>";
        "K" = ":prev-folder<Enter>";
        "H" = ":collapse-folder<Enter>";
        "L" = ":expand-folder<Enter>";

        "v" = ":mark -t<Enter>";
        "x" = ":mark -t<Enter>:next<Enter>";
        "V" = ":mark -v<Enter>";

        "T" = ":toggle-threads<Enter>";

        "<Enter>" = ":view<Enter>";
        "d" = ":prompt 'Really delete this message?' 'delete-message'<Enter>";
        "D" = ":delete<Enter>";
        "A" = ":archive flat<Enter>";

        "C" = ":compose<Enter>";

        "rr" = ":reply -a<Enter>";
        "rq" = ":reply -aq<Enter>";
        "Rr" = ":reply<Enter>";
        "Rq" = ":reply -q<Enter>";

        "c" = ":cf<space>";
        "$" = ":term<space>";
        "!" = ":term<space>";
        "|" = ":pipe<space>";

        "/" = ":search<space>";
        "\\" = ":filter<space>";
        "n" = ":next-result<Enter>";
        "N" = ":prev-result<Enter>";
        "<Esc>" = ":clear<Enter>";
      };

      "messages:folder=Drafts" = {
        "<Enter>" = ":recall<Enter>";
      };

      view = {
        "/" = ":toggle-key-passthrough<Enter>/";
        "q" = ":close<Enter>";
        "O" = ":open<Enter>";
        "S" = ":save<space>";
        "|" = ":pipe<space>";
        "D" = ":delete<Enter>";
        "A" = ":archive flat<Enter>";

        "<C-l>" = ":open-link <space>";

        "f" = ":forward<Enter>";
        "rr" = ":reply -a<Enter>";
        "rq" = ":reply -aq<Enter>";
        "Rr" = ":reply<Enter>";
        "Rq" = ":reply -q<Enter>";

        "H" = ":toggle-headers<Enter>";
        "<C-k>" = ":prev-part<Enter>";
        "<C-j>" = ":next-part<Enter>";
        "J" = ":next<Enter>";
        "K" = ":prev<Enter>";
      };

      "view::passthrough" = {
        "$noinherit" = true;
        "$ex" = "<C-x>";
        "<Esc>" = ":toggle-key-passthrough<Enter>";
      };

      compose = {
        "$noinherit" = "true";
        "$ex" = "<C-x>";
        "<C-k>" = ":prev-field<Enter>";
        "<C-j>" = ":next-field<Enter>";
        "<A-p>" = ":switch-account -p<Enter>";
        "<A-n>" = ":switch-account -n<Enter>";
        "<tab>" = ":next-field<Enter>";
        "<C-p>" = ":prev-tab<Enter>";
        "<C-n>" = ":next-tab<Enter>";
      };

      "compose::editor" = {
        "$noinherit" = "true";
        "$ex" = "<C-x>";
        "<C-k>" = ":prev-field<Enter>";
        "<C-j>" = ":next-field<Enter>";
        "<C-p>" = ":prev-tab<Enter>";
        "<C-n>" = ":next-tab<Enter>";
      };

      "compose::review" = {
        "y" = ":send<Enter>";
        "n" = ":abort<Enter>";
        "p" = ":postpone<Enter>";
        "q" = ":choose -o d discard abort -o p postpone postpone<Enter>";
        "e" = ":edit<Enter>";
        "a" = ":attach<space>";
        "d" = ":detach<space>";
      };

      terminal = {
        "$noinherit" = "true";
        "$ex" = "<C-x>";

        "<C-p>" = ":prev-tab<Enter>";
        "<C-n>" = ":next-tab<Enter>";
      };
    };
    extraConfig = {
      general.unsafe-accounts-conf = true;
      ui = {
        styleset-name = "catppuccin-mocha";
        this-day-time-format = ''"           15:04"'';
        this-year-time-format = "Mon Jan 02 15:04";
        timestamp-format = "2006-01-02 15:04";

        spinner = "[ ⡿ ],[ ⣟ ],[ ⣯ ],[ ⣷ ],[ ⣾ ],[ ⣽ ],[ ⣻ ],[ ⢿ ]";
        border-char-vertical = "┃";
        border-char-horizontal = "━";
      };
      viewer = {
        always-show-mime = true;
      };
      compose = {
        no-attachment-warning = "^[^>]*attach(ed|ment)";
      };
      filters = {
        "text/plain" = "colorize";
        "text/html" = "html";
        "text/calendar" = "calendar";
        "message/delivery-status" = "colorize";
        "message/rfc822" = "colorize";
        "image/*" = "${pkgs.catimg}/bin/catimg -";
      };
    };
  };

  programs.notmuch = {
    enable = true;
    new.tags = [ "new" ];
    search.excludeTags = [
      "trash"
      "deleted"
      "spam"
    ];
    maildir.synchronizeFlags = true;
  };

  programs.afew = {
    enable = true;
    extraConfig = ''
      [Filter.1]
      message = "Tag GitHub notifications"
      tags = +github
      query = from:noreply@github.com OR from:notifications@github.com

      [Filter.2]
      query = "folder:autistici/Inbox"
      tags = +autistici
      message = "Tag personal autistici emails"

      [Filter.3]
      query = "not folder:autistici/Inbox"
      tag = -new
      message = "Sanity check: remove the new tag for emails moved out from Inbox"

      [Filter.4]
      query = "not folder:autistici/Inbox"
      tag = -new
      message = "Sanity check: remove the new tag for emails moved out from Inbox"

      [Filter.5]
      query = "not folder:autistici/Sent"
      tag = +sent
      message = "Sanity check: add the sent tag for emails in Sent"

      [Filter.6]
      query = "not folder:autistici/Drafts"
      tag = +draft
      message = "Sanity check: add the draft tag for emails in Draft"

      [MailMover]
      folders = autistici/Inbox
      rename = true

      autistici/Inbox = 'tag:archive':autistici/Archive 'tag:github':autistici/GitHub 'NOT tag:new':autistici/Trash
    '';
  };

  systemd.user.services.emails-watcher = {
    Unit.Description = "Send notifications when new emails arrive";
    Install = {
      WantedBy = [ "default.target" ];
    };
    Service = {
      ExecStart = "${lib.getExe fleetFlake.packages.${pkgs.system}.emails-watcher}";
      Environment = [ "INBOX_NEW=~/Maildir/autistici/Inbox/new" ];
    };
  };

  accounts.email = {
    accounts.autistici = {
      aerc.enable = true;
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
        expunge = "both";
        remove = "both";
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
