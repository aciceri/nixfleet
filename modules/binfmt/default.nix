{
  boot.binfmt.emulatedSystems = ["i686-linux" "aarch64-linux" "riscv64-linux"];
  nix.extraOptions = ''
    extra-platforms = aarch64-linux arm-linux i686-linux riscv64-linux
  '';

  # XXX For some reason `docker buildx` isn't aware of this:
  # https://discourse.nixos.org/t/docker-ignoring-platform-when-run-in-nixos/21120/14
}
