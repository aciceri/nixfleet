_: {
  disk = {
    # emmc = {
    #   device = "/dev/mmcblk2";
    #   type = "disk";
    #   content = {
    #     type = "table";
    #     format = "gpt";
    #     partitions = [
    #       {
    #         name = "root";
    #         start = "1MiB";
    #         end = "-4G";
    #         part-type = "primary";
    #         bootable = false;
    #         content = {
    #           type = "filesystem";
    #           format = "ext4";
    #           mountpoint = "/";
    #         };
    #       }
    #       {
    #         name = "swap";
    #         start = "-4G";
    #         end = "100%";
    #         part-type = "primary";
    #         content = {
    #           type = "swap";
    #           randomEncryption = true;
    #         };
    #       }
    #     ];
    #   };
    # };
    ssd = {
      device = "/dev/nvme0n1";
      type = "disk";
      content = {
        type = "table";
        format = "gpt";
        partitions = [
          {
            name = "ESP";
            start = "1MiB";
            end = "1024MiB";
            bootable = true;
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          }
          {
            name = "root";
            start = "1024MiB";
            end = "-8G";
            part-type = "primary";
            bootable = false;
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
            };
          }
          {
            name = "swap";
            start = "-8G";
            end = "100%";
            part-type = "primary";
            content = {
              type = "swap";
              randomEncryption = true;
            };
          }
        ];
      };
    };
  };
}
