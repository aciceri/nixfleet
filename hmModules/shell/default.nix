{
  config,
  lib,
  pkgs,
  age,
  ...
}: {
  programs.bat.enable = true;

  programs.direnv = {
    enable = true;
    config = {
      warn_timeout = "60s"; # default was 5s
    };
    nix-direnv.enable = true;
  };

  services.lorri.enable = false; # I'm not using it

  programs.exa = {
    enable = true;
    enableAliases = true;
  };

  programs.zoxide.enable = true;

  programs.zellij.enable = true;

  programs.fzf.enable = true;

  programs.vim.enable = true;

  programs.command-not-found.enable = true;

  programs.starship = {
    enable = true;
    settings = {
      character = {
        success_symbol = "[λ](bold green)";
        error_symbol = "[λ](bold red)";
      };
      nix_shell = {
        symbol = "❄";
      };
    };
  };

  # Playing with it sometimes
  programs.nushell = {
    enable = true;
    configFile.text = ''
      let-env config = {
        show_banner: false
        ls: {
          use_ls_colors: true # use the LS_COLORS environment variable to colorize output
          clickable_links: true # enable or disable clickable links. Your terminal has to support links.
        }
        rm: {
          always_trash: true # always act as if -t was given. Can be overridden with -p
        }
        cd: {
          abbreviations: true # allows `cd s/o/f` to expand to `cd some/other/folder`
        }
        table: {
          mode: compact # basic, compact, compact_double, light, thin, with_love, rounded, reinforced, heavy, none, other
          index_mode: always # "always" show indexes, "never" show indexes, "auto" = show indexes when a table has "index" column
          trim: {
            methodology: wrapping # wrapping or truncating
            wrapping_try_keep_words: true # A strategy used by the 'wrapping' methodology
            truncating_suffix: "..." # A suffix used by the 'truncating' methodology
          }
        }
        history: {
          max_size: 10000 # Session has to be reloaded for this to take effect
          sync_on_enter: true # Enable to share history between multiple sessions, else you have to close the session to write history to file
          file_format: "plaintext" # "sqlite" or "plaintext"
        }
        completions: {
          case_sensitive: false # set to true to enable case-sensitive completions
          quick: true  # set this to false to prevent auto-selecting completions when only one remains
          partial: true  # set this to false to prevent partial filling of the prompt
          algorithm: "prefix"  # prefix or fuzzy
          external: {
            enable: true # set to false to prevent nushell looking into $env.PATH to find more suggestions, `false` recommended for WSL users as this look up my be very slow
            max_results: 100 # setting it lower can improve completion performance at the cost of omitting some options
            completer: null # check 'carapace_completer' above as an example
          }
        }
        filesize: {
          metric: true # true => KB, MB, GB (ISO standard), false => KiB, MiB, GiB (Windows standard)
          format: "auto" # b, kb, kib, mb, mib, gb, gib, tb, tib, pb, pib, eb, eib, zb, zib, auto
        }
      }
    '';
  };

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    enableSyntaxHighlighting = true;
    enableVteIntegration = true;
    autocd = true;
    oh-my-zsh = {
      enable = true;
      plugins = [
        "ag"
        "cabal"
        "colored-man-pages"
        "colorize"
        "command-not-found"
        "fzf"
        "git"
        "nomad"
        "pass"
        "python"
        "sudo"
        "terraform"
        "thefuck"
      ];
    };
    shellAliases = {
      "cat" = "bat";
      "emw" = "emacsclient -c";
      "emnw" = "emacsclient -c -nw";
      "pass-clone" = "[ -d .password-store ] && echo 'Password store archive already exists' || git clone git@git.sr.ht:~zrsk/pass ~/.password-store";
      "getpass" = "pass show $(find .password-store/ -name \"*.gpg\" | sed \"s/\\.password-store\\/\\(.*\\)\\.gpg$/\\1/g\" | fzf) | wl-copy; ((sleep 60 && wl-copy --clear) &)";
      "n" = "nom";
    };
    loginExtra = "[[ -z $DISPLAY && $TTY = /dev/tty1 ]] && exec sway";
    envExtra = ''
      [ $TERM = "dumb" ] && unsetopt zle && PS1='$ ' # for Emacs TRAMP mode
      export CACHIX_AUTH_TOKEN=$(cat ${age.secrets.cachix-personal-token.path})
    '';
    initExtra = ''
      # Don't enable VIM emulation when in Emacs
      [[ -z $INSIDE_EMACS ]] && source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh

      # When enabling starship, home-manager add an `initExtra` rule to disable it when in Emacs but not with VTerm,
      # since I use also `eat` besides `vterm` the following line is needed
      [[ "$INSIDE_EMACS" =~ "eat" ]] && eval "$(${config.home.profileDirectory}/bin/starship init zsh)"
    '';
  };

  home.packages = with pkgs; [
    thefuck
    htop-vim
    dig.dnsutils
    zsh-completions
    nix-zsh-completions
    # nom # FIXME disable on aarch64-linux, breaks everything :(
  ];
}
