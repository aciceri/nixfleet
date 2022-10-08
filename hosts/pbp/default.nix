{
  fleetModules,
  pkgs,
  lib,
  ...
}: {
  imports =
    [
      ./hardware-configuration.nix
    ]
    ++ fleetModules [
      "common"
      "ssh"
      "ccr"
      #"mara"
    ];

  ccr.enable = true;
  # mara.enable = true;
}
