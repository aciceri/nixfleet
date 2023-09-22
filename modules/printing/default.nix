{
  config,
  lib,
  pkgs,
  ...
}: {
  services.avahi.enable = true;
  # Important to resolve .local domains of printers, otherwise you get an error
  # like  "Impossible to connect to XXX.local: Name or service not known"
  services.avahi.nssmdns = true;
  hardware.sane.enable = true;

  services.paperless = {
    enable = true;
    passwordFile = builtins.toFile "password" "admin";
  };

  services.printing = {
    enable = true;
    drivers = [
      (pkgs.callPackage ./driver.nix {})
    ];
  };
}
