{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.password-store = {
    enable = true;
    settings = {
      PASSWORD_STORE_DIR = "/home/ccr/.password-store";
    };
  };
  services.password-store-sync.enable = true;
}
