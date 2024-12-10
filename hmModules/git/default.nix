{
  pkgs,
  username,
  ...
}:
let
  config = {
    name = "Andrea Ciceri";
    email = "andrea.ciceri@autistici.org";
  };
in
{
  imports = [
    ../gitui
    ../lazygit
  ];

  home.packages = [ pkgs.git-credential-manager ];

  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;

    extraConfig = {
      ui.color = true;
      pull.rebase = false;
      rebase.autostash = true;
      github.user = "aciceri";

      user.signingKey = "/home/${username}/.ssh/id_rsa";
      gpg.format = "ssh";
      commit.gpgsign = true;

      credential.helper = "manager";
      credential.credentialStore = "cache";
    };

    userName = config.name;
    userEmail = config.email;

    extraConfig.url = {
      "ssh://git@github.com/".insteadOf = "https://github.com/";
      # Workaround for https://github.com/rust-lang/cargo/issues/3381#issuecomment-1193730972
      "https://github.com/rust-lang/crates.io-index".insteadOf = "https://github.com/rust-lang/crates.io-index";
      "https://github.com/RustSec/advisory-db".insteadOf = "https://github.com/RustSec/advisory-db";
    };

    delta = {
      enable = false;
      options = {
        features = "decorations";
        delta = {
          line-numbers = true;
        };
      };
    };

    difftastic = {
      enable = false; # it gives problem with `magit-todos` in emacs
      background = "dark";
    };

    diff-so-fancy.enable = false;
  };
}
