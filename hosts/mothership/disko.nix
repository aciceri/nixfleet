{
  lib,
  disks ? ["/dev/nvme0n1" "/dev/nvme1n1"],
  ...
}: {
  disk = {
    x = {
      type = "disk";
      device = builtins.elemAt disks 0;
      content = {
        type = "table";
        format = "gpt";
        partitions = [
          {
            name = "ESP";
            start = "0";
            end = "960MiB";
            fs-type = "fat32";
            bootable = true;
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          }
          {
            name = "zfs";
            start = "1GiB";
            end = "100%";
            content = {
              type = "zfs";
              pool = "zroot";
            };
          }
        ];
      };
    };
    y = {
      type = "disk";
      device = builtins.elemAt disks 1;
      content = {
        type = "table";
        format = "gpt";
        partitions = [
          {
            name = "zfs";
            start = "1GiB";
            end = "100%";
            content = {
              type = "zfs";
              pool = "zroot";
            };
          }
        ];
      };
    };
  };
  zpool = {
    zroot = {
      type = "zpool";
      mode = "mirror";
      rootFsOptions = {
        compression = "lz4";
        "com.sun:auto-snapshot" = "false";
      };
      options.acltype = "posix";
      datasets = {
        root = {
          type = "zfs_fs";
          options = {
            mountpoint = "legacy";
            autotrim = "on";
            ashift = "12";
            acltype = "posix";
            dnodesize = "auto";
            normalization = "formD";
            relatime = "on";
            xattr = "sa";
          };
          mountpoint = "/";
        };
      };
    };
  };
}
