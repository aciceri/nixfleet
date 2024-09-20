let
  ssd = "/dev/disk/by-id/ata-CT240BX300SSD1_1739E1042F3C";
in
# hd1 = "/dev/disk/by-id/ata-WDC_WD10EADS-22M2B0_WD-WCAV52709550";
# hd2 = "/dev/disk/by-id/ata-WDC_WD10EADX-22TDHB0_WD-WCAV5V359530";
# old_hd = "/dev/disk/by-id/ata-WDC_WD5000AAKX-08U6AA0_WD-WCC2E5TR40FU";
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
    };
  };
}
