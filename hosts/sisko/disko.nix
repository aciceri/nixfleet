let
  emmc = "/dev/mmcblk0";
  # hd1 = "/dev/disk/by-id/ata-WDC_WD10EADS-22M2B0_WD-WCAV52709550";
  # hd2 = "/dev/disk/by-id/ata-WDC_WD10EADX-22TDHB0_WD-WCAV5V359530";
  hd = "/dev/disk/by-id/ata-WDC_WD10EADS-22M2B0_WD-WCAV52709550-part1";
  # old_hd = "/dev/disk/by-id/ata-WDC_WD5000AAKX-08U6AA0_WD-WCC2E5TR40FU";
in {
  disko.devices = {
    disk = {
      emmc = {
        type = "disk";
        device = emmc;
        content = {
          type = "table";
          format = "gpt";
          partitions = [
            {
              start = "32.8kB";
              end = "12.6MB";
              name = "uboot";
              bootable = true;
            }
            {
              name = "NIXOS_ROOTFS";
              start = "13.6MB";
              end = "100%";
              flags = ["legacy_boot"];
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            }
          ];
        };
      };
      # hd = {
      #   type = "disk";
      #   device = hd;
      #   content = {
      #     type = "table";
      #     format = "gpt";
      #     partitions = [
      #       {
      #         name = "hd";
      #         start = "0%";
      #         end = "100%";
      #         content = {
      #           type = "filesystem";
      #           format = "ext4";
      #           mountpoint = "/mnt/hd";
      #         };
      #       }
      #     ];
      #   };
      # };
      # hd1 = {
      #   type = "disk";
      #   device = hd1;
      #   content = {
      #     type = "table";
      #     format = "gpt";
      #     partitions = [
      #       {
      #         name = "primary";
      #         start = "0";
      #         end = "100%";
      #         content = {
      #           type = "mdraid";
      #           name = "raid1";
      #         };
      #       }
      #     ];
      #   };
      # };
      # hd2 = {
      #   type = "disk";
      #   device = hd2;
      #   content = {
      #     type = "table";
      #     format = "gpt";
      #     partitions = [
      #       {
      #         name = "primary";
      #         start = "0";
      #         end = "100%";
      #         content = {
      #           type = "mdraid";
      #           name = "raid1";
      #         };
      #       }
      #     ];
      #   };
      # };
    };

    # mdadm = {
    #   raid1 = {
    #     type = "mdadm";
    #     level = 1;
    #     content = {
    #       type = "table";
    #       format = "gpt";
    #       partitions = [
    #         {
    #           name = "primary";
    #           start = "0";
    #           end = "100%";
    #           content = {
    #             type = "filesystem";
    #             format = "ext4";
    #             mountpoint = "/mnt/raid";
    #           };
    #         }
    #       ];
    #     };
    #   };
    # };
  };
}