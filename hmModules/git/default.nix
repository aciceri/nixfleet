{pkgs, ...}: let
  config = {
    name = "Andrea Ciceri";
    email = "andrea.ciceri@autistici.org";
  };
in {
  imports = [../gitui ../lazygit];
  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;

    extraConfig = {
      ui.color = true;
      pull.rebase = false;
      rebase.autostash = true;
      github.user = "aciceri";

      user.signingKey = "/home/ccr/.ssh/id_rsa";
      gpg.format = "ssh";
      commit.gpgsign = true;

      core.editor = "hx";
    };

    userName = config.name;
    userEmail = config.email;
    # signing = {
    #   signByDefault = true;
    #   key = config.email;
    # };

    extraConfig.url = {
      "ssh://git@github.com/".insteadOf = "https://github.com/";
      # Workaround: https://github.com/rust-lang/cargo/issues/3381#issuecomment-1193730972
      "https://github.com/rust-lang/crates.io-index".insteadOf = "https://github.com/rust-lang/crates.io-index";
      "https://github.com/RustSec/advisory-db".insteadOf = "https://github.com/RustSec/advisory-db";
    };

    delta = {
      enable = false; # Playing with difftastic at the moment
      options = {
        features = "decorations";
        delta = {
          line-numbers = true;
        };
      };
    };

    difftastic = {
      enable = true;
      background = "dark";
    };
  };
}
