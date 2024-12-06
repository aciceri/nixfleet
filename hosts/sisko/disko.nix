let
  ssd = "/dev/disk/by-id/ata-CT240BX300SSD1_1739E1042F3C";
  hd = "/dev/disk/by-id/ata-ST12000NM0558_ZHZ6006Q";
in
{
  disko.devices = {
    nodev."/" = {
      fsType = "tmpfs";
      mountOptions = [
        "size=1024M"
        "defaults"
        "mode=755"
      ];
    };
    disk = {
      ssd = {
        device = ssd;
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              label = "ESP";
              type = "EF00";
              size = "1024M";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            nixroot = {
              size = "100G";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/nix";
              };
            };
            persist = {
              size = "100G";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/persist";
              };
            };
            tmp = {
              end = "0";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/tmp";
              };
            };
          };
        };
      };
      hd = {
        device = hd;
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            root = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "xfs";
                mountpoint = "/mnt/hd";
                mountOptions = [
                  "nofail"
                ];
              };
            };
          };
        };
      };
      #   hd = {
      #     type = "disk";
      #     device = hd;
      #     content = {
      #       type = "gpt";
      #       partitions = {
      #         zfs = {
      #           size = "100%";
      #           content = {
      #             type = "zfs";
      #             pool = "zroot";
      #           };
      #         };
      #       };
      #     };
      #   };
      # };
      # zpool = {
      #   zroot = {
      #     type = "zpool";
      #     rootFsOptions = {
      #       compression = "lz4";
      #       acltype = "posixacl";
      #       xattr = "sa";
      #       "com.sun:auto-snapshot" = "true";
      #       mountpoint = "none";
      #     };
      #     datasets = {
      #       "root" = {
      #         type = "zfs_fs";
      #         options.mountpoint = "/mnt/hd";
      #         mountpoint = "/mnt/hd";
      #       };
      #       "root/torrent" = {
      #         type = "zfs_fs";
      #         options.mountpoint = "/mnt/hd/torrent";
      #         mountpoint = "/mnt/hd/torrent";
      #       };
      #     };
      #  };
    };
  };
}
