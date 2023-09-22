{
  config,
  lib,
  pkgs,
  ...
}: {
  boot.binfmt.emulatedSystems = ["aarch64-linux" "i686-linux" "riscv64-linux"];
  nix.extraOptions = ''
    extra-platforms = aarch64-linux arm-linux i686-linux
  '';
}
