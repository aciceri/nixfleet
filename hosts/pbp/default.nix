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
      # "mara"
      # "xfce"
      "battery"
      "printing"
      "wireguard-client"
    ];

  ccr = {
    enable = true;
    modules = [
      "shell"
      "mpv"
      # "firefox"
      "git"
      # "chrome"
      # "udiskie"
      # "emacs"
    ];
  };
  # mara = {
  #   enable = true;
  #   modules = [
  #     "shell"
  #     "mpv"
  #     "firefox"
  #     "git"
  #     "chrome"
  #     "udiskie"
  #   ];
  #   packages = with pkgs; [
  #     remmina
  #     rdesktop
  #     freerdp
  #   ];
  # };

  home-manager.users.ccr = {
    programs.chromium.package = lib.mkForce pkgs.chromium;
  };
}
