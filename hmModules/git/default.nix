{pkgs, ...}: let
  config = {
    name = "Andrea Ciceri";
    email = "andrea.ciceri@autistici.org";
  };
in {
  home.packages = [pkgs.gitoxide];
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
    };

    userName = config.name;
    userEmail = config.email;
    # signing = {
    #   signByDefault = true;
    #   key = config.email;
    # };

    extraConfig.url = {
      "ssh://git@github.com/" = {insteadOf = "https://github.com/";};
    };

    delta = {
      enable = true;
      options = {
        features = "decorations";
        delta = {
          line-numbers = true;
        };
      };
    };
  };
}
