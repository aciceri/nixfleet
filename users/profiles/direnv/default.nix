{
  programs.direnv = {
    enable = true;
    config = {
      warn_timeout = "60s"; # default was 5s
    };
    nix-direnv = {
      enable = true;
      enableFlakes = true;
    };
  };
}
