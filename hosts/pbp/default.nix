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
      "mara"
      "xfce"
      "battery"
      "printing"
    ];

  ccr.enable = true;
  mara = {
    enable = true;
    modules = [
      "shell"
      "mpv"
      "firefox"
      "git"
      "chrome"
      "udiskie"
    ];
  };

  home-manager.users.mara = {
    programs.chromium.package = lib.mkForce pkgs.chromium;
  };

  i18n.defaultLocale = lib.mkForce "it_IT.UTF-8";
}
