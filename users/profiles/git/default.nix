{
  programs.git = {
    enable = true;

    extraConfig = {
      pull.rebase = false;
    };

    userName = "aciceri";
    userEmail = "andrea.ciceri@autistici.org";
    signing = {
      signByDefault = true;
      key = "andrea.ciceri@autistici.org";
    };
    extraConfig = {
      url = {
        "ssh://git@github.com/" = { insteadOf = https://github.com/; };
      };
    };

  };
}
