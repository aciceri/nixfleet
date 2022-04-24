{ pkgs, config, ... }:
{
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    autocd = true;
    plugins = [
      {
        name = "nix-zsh-completions";
        src = pkgs.nix-zsh-completions;
        file = "share/zsh/plugins/nix/nix-zsh-completions.plugin.zsh";
      }
      {
        name = "spaceship";
        file = "share/zsh/themes/spaceship.zsh-theme";
        src = pkgs.spaceship-prompt;
      }
      {
        name = "zsh-fzf-tab";
        file = "share/fzf-tab/fzf-tab.plugin.zsh";
        src = pkgs.zsh-fzf-tab;
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
        "command-not-found"
        "colored-man-pages"
        "colorize"
      ];
    };
    shellAliases = {
      "pass-clone" = "[ -d .password-store ] && echo 'Password store archive already exists' || git clone git@git.sr.ht:~zrsk/pass ~/.password-store";
      "getpass" = "pass show $(find .password-store/ -name \"*.gpg\" | sed \"s/\\.password-store\\/\\(.*\\)\\.gpg$/\\1/g\" | fzf) | wl-copy; ((sleep 60 && wl-copy --clear) &)";
      "cat" = "bat";
      "em" = "[[ -z \$XDG_CURRENT_DESKTOP ]] && emacsclient -c -nw || emacsclient -c";
      "emw" = "emacsclient -c";
      "emnw" = "emacsclient -c -nw";
    };
    localVariables = {
      PASSWORD_STORE_DIR = "/home/ccr/.password-store";
      SPACESHIP_TIME_SHOW = "true";
      SPACESHIP_USER_SHOW = "always";
      SPACESHIP_HOST_SHOW = "always";
      EDITOR = "em";
      NIX_BUILD_SHELL = "${pkgs.zsh-nix-shell}/scripts/buildShellShim.zsh";
      PROMPT = "\\\${IN_NIX_SHELL:+[nix-shell] }$PROMPT";
    };
    loginExtra = "[[ -z $DISPLAY && $TTY = /dev/tty1 ]] && exec sway";
    initExtra =
      if pkgs.stdenv.hostPlatform.isDarwin
      then "if test -e /etc/static/bashrc; then source /etc/static/bashrc > /dev/null 2>&1; fi"
      else "";
  };

  programs.command-not-found.enable = true;
}
