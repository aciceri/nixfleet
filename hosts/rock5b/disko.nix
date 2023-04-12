{emmc ? "/dev/mmcblk0", ...}: {
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
              type = "partition";
              start = "32.8kB";
              end = "12.6MB";
              name = "uboot";
              bootable = true;
            }
            {
              type = "partition";
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
    };
  };
}
