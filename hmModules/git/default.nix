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
    };

    userName = config.name;
    userEmail = config.email;
    signing = {
      signByDefault = true;
      key = config.email;
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
