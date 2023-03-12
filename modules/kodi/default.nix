{
  config,
  lib,
  pkgs,
  ...
}: {
  services.xserver = {
    enable = true;
    desktopManager.kodi = {
      enable = true;
      package = pkgs.kodi.withPackages (ps:
        with ps; [
          joystick
          youtube
          libretro
          libretro-mgba
        ]);
    };
    displayManager.autoLogin = {
      enable = true;
      user = "kodi";
    };
  };

  users.extraUsers.kodi = {
    isNormalUser = true;
    uid = 1002;
  };

  networking.firewall = {
    allowedTCPPorts = [8080];
    allowedUDPPorts = [8080];
  };

  # environment.systemPackages = with pkgs; [xboxdrv cifs-utils];
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

  # systemd.services.xboxdrv = {
  #   wantedBy = ["multi-user.target"];
  #   after = ["network.target"];
  #   serviceConfig = {
  #     Type = "forking";
  #     User = "root";
  #     ExecStart = ''${pkgs.xboxdrv}/bin/xboxdrv --daemon --detach --pid-file /var/run/xboxdrv.pid --dbus disabled --silent --deadzone 4000 --deadzone-trigger 10% --mimic-xpad-wireless'';
  #   };
  # };

  # services.xserver.config = ''
  #   Section "InputClass"
  #        Identifier "joystick catchall"
  #        MatchIsJoystick "on"
  #        MatchDevicePath "/dev/input/event*"
  #    Driver "evdev"
  #        Option "StartKeysEnabled" "False"
  #        Option "StartMouseEnabled" "False"
  #   EndSection
  # '';
  # boot.blacklistedKernelModules = ["xpad"];
}
