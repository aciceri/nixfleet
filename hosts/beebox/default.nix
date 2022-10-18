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
      "audio"
      "dbus"
      "bluetooth"
      "kodi"
      "udisks2"
    ];

  ccr.enable = true;
}
