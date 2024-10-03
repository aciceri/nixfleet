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
    plugins = [
      # {
      #   name = "fifc";
      #   src = pkgs.fishPlugins.fifc.src;
      # }
      {
        name = "z";
        src = pkgs.fishPlugins.z.src;
      }
    ];
    shellInit =
      ''
        fish_vi_key_bindings
      ''
      + lib.optionalString (builtins.hasAttr "cachix-personal-token" age.secrets) ''
        export CACHIX_AUTH_TOKEN=$(cat ${age.secrets.cachix-personal-token.path})
      '';
    shellAliases = {
      "cat" = "bat";
    };
  };

  home.packages =
    with pkgs;
    [
      thefuck
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
