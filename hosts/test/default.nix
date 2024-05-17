{
  fleetModules,
  lib,
  config,
  pkgs,
  ...
}: {
  imports =
    fleetModules [
      "common"
      "ssh"
      "nix"
    ]
    ++ [
      ./disko.nix
    ];
}
