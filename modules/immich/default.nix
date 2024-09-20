{ config, ... }:
let
  nixpkgsImmich = builtins.getFlake "github:NixOS/nixpkgs/c0ee4c1770aa1ef998c977c4cc653a07ec95d9bf";
in
{
  containers.nextcloud = {
    nixpkgs = nixpkgsImmich;
    autoStart = true;
    privateNetwork = true;
    # hostAddress = "192.168.100.10";
    # localAddress = "192.168.100.11";
    # hostAddress6 = "fc00::1";
    # localAddress6 = "fc00::2";
    config =
      {
        ...
      }:
      {
        services.immich = {
          enable = true;
        };
      };
  };
}
