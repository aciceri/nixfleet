{
  fleetFlake,
  fleetModules,
  lib,
  pkgs,
  config,
  ...
}: {
  imports =
    fleetModules [
      "common"
      "ssh"
      "ccr"
      "wireguard-client"
      "minidlna"
      "transmission"
      "hercules-ci"
    ]
    ++ [
      ./disko.nix
    ];

  ccr.enable = true;

  services.rock5b-fan-control.enable = true;

  nixpkgs.hostPlatform = "aarch64-linux";

  swapDevices = [];

  boot.loader = {
    grub.enable = false;
    generic-extlinux-compatible.enable = true;
  };

  # fileSystems."/mnt/film" = {
  #   device = "//ccr.ydns.eu/film";
  #   fsType = "cifs";
  #   options = let
  #     credentials = pkgs.writeText "credentials" ''
  #       username=guest
  #       password=
  #     '';
  #   in ["credentials=${credentials},x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s"];
  # };
  # fileSystems."/mnt/archivio" = {
  #   device = "//ccr.ydns.eu/archivio";
  #   fsType = "cifs";
  #   options = let
  #     credentials = pkgs.writeText "credentials" ''
  #       username=guest
  #       password=
  #     '';
  #   in ["credentials=${credentials},x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s"];
  # };

  environment.systemPackages = with pkgs; [
    # kodi-rock5b
    cifs-utils
  ];

  # users.extraUsers.kodi = {
  #   isNormalUser = true;
  #   uid = 1002;
  #   extraGroups = ["video" "input"];
  # };

  # networking.firewall.allowedTCPPorts = [
  #   8080 # kodi control
  #   80
  # ];

  # programs.bash.loginShellInit = ''
  #   [[ "$(tty)" == '/dev/tty1' ]] && \
  #   [[ "$(whoami)" == 'kodi' ]] && \
  #   ${pkgs.kodi-rock5b}/bin/kodi-standalone

  # '';

  # Waiting for https://github.com/NixOS/nixpkgs/issues/140304
  # services.getty = let
  #   script = pkgs.writeText "login-program.sh" ''
  #     if [[ "$(tty)" == '/dev/tty1' ]]; then
  #       ${pkgs.shadow}/bin/login -f kodi;
  #     else
  #       ${pkgs.shadow}/bin/login;
  #     fi
  #   '';
  # in {
  #   loginProgram = "${pkgs.bash}/bin/sh";
  #   loginOptions = toString script;
  #   extraArgs = ["--skip-login"];
  # };
}
