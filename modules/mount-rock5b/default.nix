{
  pkgs,
  config,
  ...
}: {
  fileSystems."/home/${config.ccr.username}/torrent" = {
    device = "//sisko.fleet/torrent";
    fsType = "cifs";
    options = let
      credentials = pkgs.writeText "credentials" ''
        username=guest
        password=
      '';
    in ["credentials=${credentials},x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s"];
  };
}
