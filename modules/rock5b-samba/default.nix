{
  services = {
    samba-wsdd = {
      enable = true;
      workgroup = "WORKGROUP";
      hostname = "rock5b";
      discovery = true;
    };

    samba = {
      enable = true;
      securityType = "user";
      settings.global = {
        "workgroup" = "WORKGROUP";
        "server string" = "rock5b";
        "netbios name" = "rock5b";
        "security" = "user";
        "map to guest" = "bad user";
        "vfs objects" = "recycle";
        "recycle:repository" = ".recycle";
        "recycle:keeptree" = "yes";
        "recycle:versions" = "yes";
      };
      shares = {
        torrent = {
          path = "/mnt/hd/torrent";
          comment = "torrent";
          "force user" = "ccr";
          browseable = "yes";
          writeable = "yes";
          "guest ok" = "yes";
          "read only" = "no";
        };
      };
    };
  };

  networking.firewall = {
    allowedTCPPorts = [
      139
      445
    ];
    allowedUDPPorts = [ 138 ];
  };
}
