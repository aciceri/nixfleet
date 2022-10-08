{
  config,
  lib,
  pkgs,
  ...
}: {
  boot.binfmt.emulatedSystems = ["aarch64-linux"];
  nix.extraOptions = ''
    extra-platforms = aarch64-linux arm-linux
  '';
}
