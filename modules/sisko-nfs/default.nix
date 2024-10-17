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

  networking.firewall.allowedTCPPorts = [ 2049 ];
}
