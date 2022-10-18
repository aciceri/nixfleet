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

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    autocd = true;
    plugins = [
      {
        name = "nix-zsh-completions";
        file = "share/zsh/plugins/nix/nix-zsh-completions.plugin.zsh";
        src = pkgs.nix-zsh-completions;
      }
      {
        name = "spaceship";
        file = "share/zsh/themes/spaceship.zsh-theme";
        src = pkgs.spaceship-prompt;
      }
      {
        name = "fast-zsh-syntax-highlighting";
        file = "share/zsh/site-functions/fast-syntax-highlighting.plugin.zsh";
        src = pkgs.zsh-fast-syntax-highlighting;
      }
    ];
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "sudo"
        "colored-man-pages"
        "colorize"
        "thefuck"
        "fzf"
      ];
    };
    shellAliases = {
      "cat" = "bat";
      "emw" = "emacsclient -c";
      "emnw" = "emacsclient -c -nw";
      "pass-clone" = "[ -d .password-store ] && echo 'Password store archive already exists' || git clone git@git.sr.ht:~zrsk/pass ~/.password-store";
      "getpass" = "pass show $(find .password-store/ -name \"*.gpg\" | sed \"s/\\.password-store\\/\\(.*\\)\\.gpg$/\\1/g\" | fzf) | wl-copy; ((sleep 60 && wl-copy --clear) &)";
    };
    localVariables = {
      PASSWORD_STORE_DIR = "/home/ccr/.password-store";
      SPACESHIP_CHAR_SYMBOL = "λ ";
      SPACESHIP_TIME_SHOW = "true";
      SPACESHIP_USER_SHOW = "always";
      SPACESHIP_HOST_SHOW = "always";
      NIX_BUILD_SHELL = "${pkgs.zsh-nix-shell}/scripts/buildShellShim.zsh";
      PROMPT = "\\\${IN_NIX_SHELL:+[nix-shell] }$PROMPT";
    };
    loginExtra = "[[ -z $DISPLAY && $TTY = /dev/tty1 ]] && exec sway";
    envExtra = ''
      [ $TERM = "dumb" ] && unsetopt zle && PS1='$ ' # for Emacs TRAMP mode
    '';
  };

  home.packages = with pkgs; [thefuck htop-vim dig.dnsutils];
}
