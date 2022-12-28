{
  config,
  lib,
  pkgs,
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

  services.lorri.enable = true;

  programs.exa = {
    enable = true;
    enableAliases = true;
  };

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
    };
    loginExtra = "[[ -z $DISPLAY && $TTY = /dev/tty1 ]] && exec sway";
    envExtra = ''
      [ $TERM = "dumb" ] && unsetopt zle && PS1='$ ' # for Emacs TRAMP mode
    '';
  };

  home.packages = with pkgs; [
    thefuck
    htop-vim
    dig.dnsutils
    zsh-completions
    nix-zsh-completions
  ];
}
