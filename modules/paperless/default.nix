{ config, ... }:
let
  domain = config.services.paperless.domain;
in
{
  services.paperless = {
    enable = true;
    domain = "paper.sisko.wg.aciceri.dev";
    address = "0.0.0.0";
    passwordFile = builtins.toFile "paperless-initial-password" "paperless";
    mediaDir = "/mnt/hd/paperless/";
    settings = {
      PAPERLESS_OCR_LANGUAGE = "ita+eng";
      PAPERLESS_CONSUMER_IGNORE_PATTERN = builtins.toJSON [
        ".DS_STORE/*"
        "desktop.ini"
      ];
      PAPERLESS_OCR_USER_ARGS = builtins.toJSON {
        optimize = 1;
        pdfa_image_compression = "lossless";
        invalidate_digital_signatures = true;
      };
      PAPERLESS_URL = "https://${domain}";
    };
  };

  environment.persistence."/persist".directories = [
    config.services.paperless.dataDir
  ];

  imports = [ ../nginx-base ];

  services.nginx.virtualHosts."domain" = {
    forceSSL = true;
    useACMEHost = "aciceri.dev";
    locations."/" = {
      proxyPass = "http://localhost:${builtins.toString config.services.paperless.port}";
    };
    extraConfig = ''
      client_max_body_size 50000M;
      proxy_redirect off;
      proxy_set_header Host $host:$server_port;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header X-Forwarded-Host $server_name;
      proxy_set_header X-Forwarded-Proto $scheme;
    '';
    serverAliases = [ "paper.sisko.zt.aciceri.dev" ];
  };
}
