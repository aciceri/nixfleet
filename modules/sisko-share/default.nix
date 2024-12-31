{
  systemd.tmpfiles.rules = [
    "d /export 770 nobody nogroup"
  ];

  fileSystems."/export/hd" = {
    device = "/mnt/hd";
    options = [ "bind" ];
  };

  services.nfs.server = {
    enable = true;
    exports = ''
      /export     10.100.0.1/24(rw,fsid=0,no_subtree_check)
      /export/hd  10.100.0.1/24(rw,nohide,insecure,no_subtree_check,no_root_squash)
    '';
  };

  systemd.services.nfs-server.preStart = ''
    chmod -R 775 /export/hd/torrent
  '';

  services.webdav = {
    enable = true;

    settings = {
      address = "0.0.0.0";
      port = 9999;
      scope = "/mnt/hd/torrent";
      modify = false;
      auth = false;
      debug = true;
      users = [ ];
    };
  };

  users.users.webdav.extraGroups = [ "transmission" ];

  networking.firewall.allowedTCPPorts = [
    2049
    9999
  ];
}
