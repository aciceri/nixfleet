{pkgs, ...}: let
  config = {
    name = "Andrea Ciceri";
    email = "andrea.ciceri@autistici.org";
  };
in {
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

    extraConfig = {
      url =
        if pkgs.stdenv.hostPlatform.isDarwin
        then {}
        else {
          "ssh://git@github.com/" = {insteadOf = https://github.com/;};
        };
    };
  };
}
