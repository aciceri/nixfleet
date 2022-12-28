{fleetModules, ...}: {
  imports =
    [
      ./hardware-configuration.nix
    ]
    ++ fleetModules [
      "common"
      "ssh"
      "ccr"
    ];

  ccr.enable = true;
}
