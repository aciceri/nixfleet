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
    package = pkgs.pass.withExtensions (e: with e; [pass-otp]);
  };
  services.password-store-sync.enable = false; # FIXME this requires `pass` every 5 minutes that run `pinentry`
}
