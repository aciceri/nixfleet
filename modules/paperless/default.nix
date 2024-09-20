{ config, ... }:
{
  services.paperless = {
    enable = true;
    address = "0.0.0.0";
    passwordFile = builtins.toFile "paperless-initial-password" "paperless";
    mediaDir = "/mnt/hd/paperless/media";
    consumptionDir = "/mnt/hd/paperless/consume";
    settings = {
      PAPERLESS_OCR_LANGUAGE = "ita+eng";
      PAPERLESS_CONSUMER_IGNORE_PATTERN = builtins.toJSON [
        ".DS_STORE/*"
        "desktop.ini"
      ];
      PAPERLESS_OCR_USER_ARGS = builtins.toJSON {
        optimize = 1;
        pdfa_image_compression = "lossless";
      };
    };
  };

  backup.paths = [
    config.services.paperless.dataDir
  ];
}
