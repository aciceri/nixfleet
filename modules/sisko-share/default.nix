{ pkgs, ... }:
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

  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
    # workgroup = "WORKGROUP";
    # hostname = "siko";
    # discovery = true;
  };

  services.avahi = {
    publish.enable = true;
    publish.userServices = true;
    # ^^ Needed to allow samba to automatically register mDNS records (without the need for an `extraServiceFile`
    #nssmdns4 = true;
    # ^^ Not one hundred percent sure if this is needed- if it aint broke, don't fix it
    enable = true;
    openFirewall = true;
  };

  services.samba = {
    enable = true;
    # global.security = "user";
    package = pkgs.samba4Full;
    # settings.global = {
    #   "workgroup" = "WORKGROUP";
    #   "server string" = "sisko";
    #   "netbios name" = "sisko";
    #   "security" = "user";
    #   "map to guest" = "bad user";
    #   "vfs objects" = "recycle";
    #   "recycle:repository" = ".recycle";
    #   "recycle:keeptree" = "yes";
    #   "recycle:versions" = "yes";
    #   "hosts allow" = "10.1.1.0. 127.0.0.1 localhost";
    # };
    settings = {
      torrent = {
        path = "/mnt/hd/torrent";
        comment = "hd";
        "force user" = "transmission";
        browseable = "yes";
        writeable = "yes";
      };
    };
  };

  users.users.webdav.extraGroups = [ "transmission" ];

  networking.firewall = {
    allowedTCPPorts = [
      2049
      9999
      139
      445
    ];
    allowedUDPPorts = [
      137
      138
    ];
  };
}
