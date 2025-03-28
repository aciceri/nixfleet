{
  lib,
  pkgs,
  age,
  hostname,
  config,
  username,
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

  programs.fd.enable = true;

  programs.direnv = {
    enable = true;
    config = {
      warn_timeout = "60s"; # default was 5s
    };
    nix-direnv.enable = true;
  };

  programs.lsd = {
    enable = true;
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
    Service = {
      ExecStartPre = "${lib.getExe' pkgs.toybox "rm"} -f ${config.programs.atuin.settings.daemon.socket_path}";
      ExecStart = "${lib.getExe pkgs.atuin} daemon";
    };
  };

  programs.atuin = {
    enable = false; # FIXME broken on bash: https://github.com/nix-community/home-manager/issues/5958
    settings = {
      daemon = {
        enabled = true;
        socket_path = "/home/${username}/.local/share/atuin/atuin.sock"; # FIXME using ~ or $HOME doesn't work: https://github.com/atuinsh/atuin/issues/2289
      };
      auto_sync = true;
      sync_frequency = "5m";
      sync_address = "http://sisko.wg.aciceri.dev:8889";
      search_mode = "fuzzy";
      style = "compact";
      enter_accept = "true";
    };
  };

  programs.bash = {
    enable = true;
    initExtra = lib.optionalString (builtins.hasAttr "cachix-personal-token" age.secrets) ''
      export CACHIX_AUTH_TOKEN=$(cat ${age.secrets.cachix-personal-token.path})
    '';
    shellAliases = {
      "cat" = "bat";
    };
  };

  programs.zoxide.enable = true;
  programs.thefuck.enable = true;
  programs.oh-my-posh = {
    enable = true;
    useTheme = "catppuccin_mocha";
  };

  programs.zellij.enableBashIntegration = false;

  # programs.fish = {
  #   enable = true;
  #   plugins = [
  #     # {
  #     #   name = "fifc";
  #     #   src = pkgs.fishPlugins.fifc.src;
  #     # }
  #     {
  #       name = "z";
  #       src = pkgs.fishPlugins.z.src;
  #     }
  #   ];
  #   shellInit =
  #     ''
  #       # fish_vi_key_bindings
  #       fish_default_key_bindings
  #     ''
  #     + lib.optionalString (builtins.hasAttr "cachix-personal-token" age.secrets) ''
  #       export CACHIX_AUTH_TOKEN=$(cat ${age.secrets.cachix-personal-token.path})
  #     '';
  #   shellAliases = {
  #     "cat" = "bat";
  #   };
  # };

  home.packages =
    with pkgs;
    [
      dig.dnsutils
      lsof
      comma
      ffmpeg-headless
      jless
      nix-melt
      nurl
      jq
      yq-go
      procs
      chafa
      hexyl
      broot
      file
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
