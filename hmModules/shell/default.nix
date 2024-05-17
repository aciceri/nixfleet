{
  config,
  lib,
  pkgs,
  age,
  fleetFlake,
  hostname,
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

  # programs.exa = {
  #   enable = false;
  #   enableAliases = true;
  # };

  # programs.fzf.enable = false;

  programs.vim.enable = true;

  programs.ssh = {
    enable = true;
    controlMaster = "auto";
  };

  # programs.starship = {
  #   enable = false;
  #   settings = {
  #     character = {
  #       success_symbol = "[👌](bold green)";
  #       error_symbol = "[🤌](bold red)";
  #     };
  #     nix_shell = {
  #       symbol = "❄ ";
  #     };
  #   };
  # };

  # Playing with it sometimes
  # programs.nushell = {
  #   enable = false;
  #   configFile.text = ''
  #     let carapace_completer = {|spans|
  #        carapace $spans.0 nushell $spans | from json
  #     }
  #     let-env config = {
  #       show_banner: false
  #       ls: {
  #         use_ls_colors: true # use the LS_COLORS environment variable to colorize output
  #         clickable_links: true # enable or disable clickable links. Your terminal has to support links.
  #       }
  #       rm: {
  #         always_trash: true # always act as if -t was given. Can be overridden with -p
  #       }
  #       cd: {
  #         abbreviations: true # allows `cd s/o/f` to expand to `cd some/other/folder`
  #       }
  #       table: {
  #         mode: compact # basic, compact, compact_double, light, thin, with_love, rounded, reinforced, heavy, none, other
  #         index_mode: always # "always" show indexes, "never" show indexes, "auto" = show indexes when a table has "index" column
  #         trim: {
  #           methodology: wrapping # wrapping or truncating
  #           wrapping_try_keep_words: true # A strategy used by the 'wrapping' methodology
  #           truncating_suffix: "..." # A suffix used by the 'truncating' methodology
  #         }
  #       }
  #       history: {
  #         max_size: 10000 # Session has to be reloaded for this to take effect
  #         sync_on_enter: true # Enable to share history between multiple sessions, else you have to close the session to write history to file
  #         file_format: "plaintext" # "sqlite" or "plaintext"
  #       }
  #       completions: {
  #         case_sensitive: false # set to true to enable case-sensitive completions
  #         quick: true  # set this to false to prevent auto-selecting completions when only one remains
  #         partial: true  # set this to false to prevent partial filling of the prompt
  #         algorithm: "fuzzy"  # prefix or fuzzy
  #         external: {
  #           enable: true # set to false to prevent nushell looking into $env.PATH to find more suggestions, `false` recommended for WSL users as this look up my be very slow
  #           max_results: 100 # setting it lower can improve completion performance at the cost of omitting some options
  #           completer: $carapace_completer # check 'carapace_completer' above as an example
  #         }
  #       }
  #       filesize: {
  #         metric: true # true => KB, MB, GB (ISO standard), false => KiB, MiB, GiB (Windows standard)
  #         format: "auto" # b, kb, kib, mb, mib, gb, gib, tb, tib, pb, pib, eb, eib, zb, zib, auto
  #       }
  #       buffer_editor: "${config.programs.helix.package}/bin/helix"
  #     }
  #   '';
  # };

  xdg.configFile = {
    "dracula-theme" = {
      target = "fish/themes/dracula.theme";
      source = let
        theme = pkgs.fetchFromGitHub {
          owner = "dracula";
          repo = "fish";
          rev = "269cd7d76d5104fdc2721db7b8848f6224bdf554";
          hash = "sha256-Hyq4EfSmWmxwCYhp3O8agr7VWFAflcUe8BUKh50fNfY=";
        };
      in "${theme}/themes/Dracula\ Official.theme";
    };
    "catppuccin-theme" = {
      target = "fish/themes/Catppuccin\ Mocha.theme";
      source = let
        theme = pkgs.fetchFromGitHub {
          owner = "catppuccin";
          repo = "fish";
          rev = "a3b9eb5eaf2171ba1359fe98f20d226c016568cf";
          hash = "sha256-shQxlyoauXJACoZWtRUbRMxmm10R8vOigXwjxBhG8ng=";
        };
      in "${theme}/themes/Catppuccin\ Mocha.theme";
    };
  };

  programs.fish = {
    enable = true;
    shellInit =
      ''
        fish_config theme choose "dracula"
        fish_config theme choose "Catppuccin Mocha"
      ''
      + lib.optionalString (builtins.hasAttr "cachix-personal-token" age.secrets) ''
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

  home.packages = with pkgs;
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
    ]
    ++ (lib.optionals (builtins.elem hostname ["kirk" "picard"]) [
      nil # TODO probably not best place
      (fleetFlake.inputs.nixd.packages.${pkgs.system}.nixd) # TODO probably not best place
      terraform-lsp # TODO probably not best place
      python3Packages.jedi-language-server # TODO probably not best place
      nodePackages.typescript-language-server # TODO probably not best place
      cntr # TODO probably not best place
      nom # FIXME disable on aarch64-linux, breaks everything :(
    ]);
}
