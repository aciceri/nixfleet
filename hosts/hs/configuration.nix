{ config, lib, pkgs, profiles, ... }:

{
  imports = with profiles; [ sshd ];

  boot = {
    initrd.availableKernelModules = [ "ohci_pci" "ehci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
    loader.grub = pkgs.lib.mkForce {
      enable = true;
      version = 2;
      device = "/dev/disk/by-id/ata-OCZ-VERTEX_TMHAK8OARSURAIF6N1A5";
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
    };
    "/mnt/archivio" = {
      device = "/dev/disk/by-label/archivio";
      fsType = "ext4";
    };
    "/mnt/film" = {
      device = "/dev/disk/by-label/film";
      fsType = "ext4";
    };
  };

  swapDevices =
    [{ device = "/dev/disk/by-label/swap"; }];

  systemd.services.standby-sdb = {
    description = "Set spindown time (sleep) for /dev/sdb ";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.hdparm}/bin/hdparm -B 127 -S 241 /dev/sdb";
    };
  };

  systemd.services.standby-sdc = {
    description = "Set spindown time (sleep) for /dev/sdc ";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.hdparm}/bin/hdparm -B 127 -S 241 /dev/sdc";
    };
  };

  systemd.services.amuled.serviceConfig.Restart = pkgs.lib.mkForce "always";
  users.users.amule = {
    isNormalUser = false;
    isSystemUser = true;
    group = "amule";
  };
  users.groups."amule" = { };

  services = {

    samba-wsdd = {
      enable = true;
      workgroup = "WORKGROUP";
      hostname = "nas";
      discovery = true;
    };

    samba = {
      enable = true;
      securityType = "user";
      extraConfig = ''
        workgroup = WORKGROUP
        server string = nas
        netbios name = nas
        security = user
        map to guest = bad user
        vfs objects = recycle
        recycle:repository = .recycle
        recycle:keeptree = yes
        recycle:versions = yes
      '';
      shares = {
        archivio = {
          path = "/mnt/archivio/archivio";
          comment = "archivio";
          "force user" = "ccr";
          browseable = "yes";
          writeable = "yes";
          "guest ok" = "yes";
          "read only" = "no";
        };
        film = {
          path = "/mnt/film/film";
          comment = "film";
          "force user" = "ccr";
          browseable = "yes";
          writeable = "yes";
          "guest ok" = "yes";
          "read only" = "no";
        };
        transmission = {
          path = "/mnt/archivio/transmission";
          comment = "transmission";
          "force user" = "transmission";
          browseable = "yes";
          writeable = "yes";
          "guest ok" = "yes";
          "read only" = "no";
        };
        amule = {
          path = "/mnt/archivio/amule";
          comment = "amule";
          "force user" = "ccr";
          browseable = "yes";
          writeable = "yes";
          "guest ok" = "yes";
          "read only" = "no";
        };
        musica = {
          path = "/mnt/film/musica";
          comment = "music";
          "force user" = "ccr";
          browseable = "yes";
          writeable = "no";
          "guest ok" = "yes";
          "read only" = "no";
        };
      };
    };

    transmission = {
      enable = true;
      port = 9091;
      # the following json is merged to this attrset, it must have `rpc-username` and `rpc-password`
      credentialsFile = "/mnt/archivio/transmission/credentials.json";
      settings = {
        download-dir = "/mnt/archivio/transmission/";
        incomplete-dir = "/mnt/archivio/transmission/.incomplete";
        incomplete-dir-enabled = true;

        rpc-whitelist-enabled = false;
        rpc-host-whitelist-enabled = false;
        rpc-authentication-required = true;
      };
    };

    amule = {
      dataDir = "/mnt/archivio/amule";
      enable = true;
      user = "amule";
    };

    calibre-web = {
      enable = true;
      listen = {
        ip = "0.0.0.0";
        port = 9092;
      };
      options.calibreLibrary = "/mnt/archivio/calibre/";
      openFirewall = true;
    };

    syncthing = {
      enable = true;
      guiAddress = "0.0.0.0:8384";
      dataDir = "/mnt/archivio/syncthing";
      user = "ccr";
      overrideDevices = false;
      overrideFolders = false;
      folders = {
        "/mnt/archivio/syncthing/camera" = {
          id = "camera";
        };
        "/mnt/archivio/syncthing/orgzly" = {
          id = "orgzly";
        };
        "/mnt/archivio/syncthing/roam" = {
          id = "roam";
        };
        "/mnt/archivio/syncthing/whatsapp" = {
          id = "whatsapp";
        };
        "/mnt/archivio/syncthing/calls" = {
          id = "calls";
        };
      };
    };

    navidrome = {
      enable = false;
      settings = {
        Address = "0.0.0.0";
        Port = 9093;
        MusicFolder = "/mnt/film/musica";
        DataFolder = "/mnt/film/musica/.navidrome";
      };
    };

    nginx = {
      enable = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      clientMaxBodySize = "10G"; # max file size for uploads
      commonHttpConfig = ''
        log_format upstream_time '$remote_addr - $remote_user [$time_local] '
                                 '"$request" $status $body_bytes_sent '
                                 '"$http_referer" "$http_user_agent"'
                                 'rt=$request_time uct="$upstream_connect_time" uht="$upstream_header_time" urt="$upstream_response_time"';
      '';
      virtualHosts = {

        "torrent.ccr.ydns.eu" = {

          enableACME = true;
          forceSSL = true;
          locations."/" = {
            proxyPass = "http://localhost:9091";

          };
        };

        "sync.ccr.ydns.eu" = {
          enableACME = true;
          addSSL = true;
          locations."/" = {
            proxyPass = "http://localhost:8384";
          };
        };

        "books.ccr.ydns.eu" = {
          enableACME = true;
          addSSL = true;
          locations."/" = {
            proxyPass = "http://localhost:9092";
          };
        };

        "music.ccr.ydns.eu" = {
          enableACME = true;
          addSSL = true;
          locations."/" = {
            proxyPass = "http://localhost:9093";
          };
        };

        "gate.ccr.ydns.eu" = {
          enableACME = true;
          addSSL = true;
          locations."/" = {
            proxyPass = "http://192.168.1.71:80";
          };
        };
      };
    };
  };

  networking.firewall = {
    enable = true;
    allowPing = true;
    allowedTCPPorts = [
      80 # http
      139 # samba
      443 # https
      445 # samba
      4712 # amule
      4711 # amule web gui
      8384 # syncthing
    ];
    allowedUDPPorts = [
      137 # samba
      138 # samba
    ];
  };

  security.acme = {
    acceptTerms = true;
    email = "andrea.ciceri@autistici.org";
  };

  nix = {
    gc = {
      automatic = true;
      options = "--delete-older-than 3d";
    };
  };

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}

