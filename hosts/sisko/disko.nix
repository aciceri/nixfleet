let
  emmc = "/dev/disk/by-id/mmc-SLD64G_0xf6be3ba0";
  ssd = "/dev/disk/by-id/ata-CT240BX300SSD1_1739E1042F3C";
  # hd1 = "/dev/disk/by-id/ata-WDC_WD10EADS-22M2B0_WD-WCAV52709550";
  # hd2 = "/dev/disk/by-id/ata-WDC_WD10EADX-22TDHB0_WD-WCAV5V359530";
  hd = "/dev/disk/by-id/ata-WDC_WD10EADS-22M2B0_WD-WCAV52709550-part1";
  # old_hd = "/dev/disk/by-id/ata-WDC_WD5000AAKX-08U6AA0_WD-WCC2E5TR40FU";
in {
  disko.devices = {
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
              size = "1G";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            root = {
              label = "root";
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            };
          };
        };
      };
    };
  };
}
