{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.sshfs ];

  fileSystems = let
    nasUser = "andrea";
    nasHost = "ccr.ydns.eu";
    fsType = "fuse.sshfs";
    target = "/home/ccr/nas";
    options = [
      "delay_connect"
      "_netdev,user"
      "idmap=user"
      "transform_symlinks"
      "identityfile=/home/andrea/.ssh/id_rsa"
      "allow_other"
      "default_permissions"
      "uid=1000"
      "gid=100"
      "nofail"
    ];
  in
    {
      "${target}/amule" = {
        inherit fsType options;
        device = "${nasUser}@${nasHost}:/mnt/archivio/amule";
      };
      "${target}/transmission" = {
        inherit fsType options;
        device = "${nasUser}@${nasHost}:/mnt/archivio/transmission";
      };
      "${target}/calibre" = {
        inherit fsType options;
        device = "${nasUser}@${nasHost}:/mnt/archivio/calibre";
      };
      "${target}/archivio" = {
        inherit fsType options;
        device = "${nasUser}@${nasHost}:/mnt/archivio/archivio";
      };
      "${target}/film" = {
        inherit fsType options;
        device = "${nasUser}@${nasHost}:/mnt/film/film";
      };
      "${target}/syncthing" = {
        inherit fsType options;
        device = "${nasUser}@${nasHost}:/mnt/archivio/syncthing";
      };
      "${target}/aria" = {
        inherit fsType options;
        device = "${nasUser}@${nasHost}:/mnt/archivio/aria2";
      };
      "${target}/musica" = {
        inherit fsType options;
        device = "${nasUser}@${nasHost}:/mnt/film/musica";
      };
    };
}
