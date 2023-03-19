_: {
  disk = {
    emmc = {
      device = "/dev/mmcblk2";
      type = "disk";
      content = {
        type = "table";
        format = "gpt";
        partitions = [
          {
            name = "root";
            type = "partition";
            start = "1MiB";
            end = "-4G";
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
            type = "partition";
            start = "-4G";
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
    ssd = {
      device = "/dev/nvme0n1";
      type = "disk";
      content = {
        type = "table";
        format = "gpt";
        partitions = [
          {
            type = "partition";
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
            name = "home";
            type = "partition";
            start = "1024MiB";
            end = "100%";
            part-type = "primary";
            bootable = false;
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/home";
            };
          }
        ];
      };
    };
  };
}
