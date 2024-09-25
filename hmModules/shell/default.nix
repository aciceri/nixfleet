{
  lib,
  pkgs,
  age,
  hostname,
  ...
}:
{
  programs.bat.enable = true;

  programs.ranger = {
    enable = true;
    settings = {
      "preview_images" = true;
      "preview_images_method" = "sixel";
    };
  };

  programs.fzf.enable = true;

  programs.ripgrep.enable = true;

  programs.direnv = {
    enable = true;
    config = {
      warn_timeout = "60s"; # default was 5s
    };
    nix-direnv.enable = true;
  };

  programs.lsd = {
    enable = false;
    enableAliases = true;
  };

  programs.vim.enable = true;

  programs.ssh = {
    enable = true;
    controlMaster = "auto";
  };

  systemd.user.services.atuind = {
    Unit.Description = "Atuin daemon";
    Install = {
      WantedBy = [ "default.target" ];
    };
    Service.ExecStart = "${lib.getExe pkgs.atuin} daemon";
  };

  programs.atuin = {
    enable = true;
    settings = {
      daemon.enabled = true;
      auto_sync = true;
      sync_frequency = "5m";
      sync_address = "http://sisko.fleet:8889";
      search_mode = "fuzzy";
      style = "compact";
    };
  };

  programs.fish = {
    enable = true;
    shellInit = lib.optionalString (builtins.hasAttr "cachix-personal-token" age.secrets) ''
      export CACHIX_AUTH_TOKEN=$(cat ${age.secrets.cachix-personal-token.path})
    '';
    shellAliases = {
      "cat" = "bat";
    };
  };

  # programs.zsh = {
  #   enable = false;  # Playing  xswith fish at the moment
  #   enableAutosuggestions = true;
  #   enableCompletion = true;
  #   enableSyntaxHighlighting = true;
  #   enableVteIntegration = true;
  #   autocd = true;
  #   oh-my-zsh = {
  #     enable = true;
  #     plugins = [
  #       "ag"
  #       "cabal"
  #       "colored-man-pages"
  #       "colorize"
  #       "command-not-found"
  #       "fzf"
  #       "git"
  #       "nomad"
  #       "pass"
  #       "python"
  #       "sudo"
  #       "terraform"
  #       "thefuck"
  #     ];
  #   };
  #   plugins = [
  #     {
  #       name = "fzf-tab";
  #       src = pkgs.fetchFromGitHub {
  #         owner = "Aloxaf";
  #         repo = "fzf-tab";
  #         rev = "c2b4aa5ad2532cca91f23908ac7f00efb7ff09c9";
  #         sha256 = "sha256-gvZp8P3quOtcy1Xtt1LAW1cfZ/zCtnAmnWqcwrKel6w=";
  #       };
  #     }
  #     {
  #       name = "fzf-tab";
  #       src = pkgs.fetchFromGitHub {
  #         owner = "Aloxaf";
  #         repo = "fzf-tab";
  #         rev = "c2b4aa5ad2532cca91f23908ac7f00efb7ff09c9";
  #         sha256 = "sha256-gvZp8P3quOtcy1Xtt1LAW1cfZ/zCtnAmnWqcwrKel6w=";
  #       };
  #     }
  #     {
  #       name = "fast-syntax-highlighting";
  #       src = pkgs.fetchFromGitHub {
  #         owner = "zdharma-continuum";
  #         repo = "fast-syntax-highlighting";
  #         rev = "13d7b4e63468307b6dcb2dadf6150818f242cbff";
  #         sha256 = "sha256-AmsexwVombgVmRvl4O9Kd/WbnVJHPTXETxBv18PDHz4=";
  #       };
  #     }
  #   ];
  #   shellAliases = {
  #     "cat" = "bat";
  #     "em" = "TERM=wezterm emacsclient -nw";
  #   };
  #   loginExtra = "[[ -z $DISPLAY && $TTY = /dev/tty1 ]] && exec dbus-run-session Hyprland";
  #   envExtra = ''
  #     # [ $TERM = "dumb" ] && unsetopt zle && PS1='$ ' # for Emacs TRAMP mode
  #   '';
  #   initExtra = ''
  #     export CACHIX_AUTH_TOKEN=$(cat ${age.secrets.cachix-personal-token.path})

  #     # Don't enable VIM emulation when in Emacs
  #     [[ -z $INSIDE_EMACS ]] && source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh

  #     # When enabling starship, home-manager add an `initExtra` rule to disable it when in Emacs but not with VTerm,
  #     # since I use also `eat` besides `vterm` the following line is needed
  #     [[ "$INSIDE_EMACS" =~ "eat" ]] && eval "$(${config.home.profileDirectory}/bin/starship init zsh)"
  #   '';
  # };

  home.packages =
    with pkgs;
    [
      thefuck
      htop-vim
      bottom
      dig.dnsutils
      lsof
      zsh-completions
      nix-zsh-completions
      comma
      carapace # used by nushell
      neovim
    ]
    ++ (lib.optionals
      (builtins.elem hostname [
        "kirk"
        "picard"
      ])
      [
        cntr # TODO probably not best place
      ]
    );
}
