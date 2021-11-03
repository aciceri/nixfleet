{ pkgs, ... }:

let
  config =
    if pkgs.stdenv.hostPlatform.isDarwin then {
      name = "Andrea Ciceri";
      email = "andrea.ciceri@beatdata.it";
    } else {
      name = "Andrea Ciceri";
      email = "andrea.ciceri@autistici.org";
    };
in
{
  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;

    extraConfig = {
      pull.rebase = false;
    };

    userName = config.name;
    userEmail = config.email;
    signing = {
      signByDefault = true;
      key = config.email;
    };

    extraConfig = {
      url = if pkgs.stdenv.hostPlatform.isDarwin then { } else {
        "ssh://git@github.com/" = { insteadOf = https://github.com/; };
      };
    };

  };
}
