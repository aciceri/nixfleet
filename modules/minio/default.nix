{
  config,
  lib,
  ...
}:
{
  imports = [ ../nginx-base ];

  services.minio = {
    enable = true;
    rootCredentialsFile = config.age.secrets.minio-credentials.path;
    region = "eu-south-1";
    dataDir = lib.mkForce [ "/mnt/hd/minio" ];
  };

  services.nginx.virtualHosts."cache.aciceri.dev" = {
    forceSSL = true;
    enableACME = true;
    extraConfig = ''
      # To allow special characters in headers
      ignore_invalid_headers off;
      # Allow any size file to be uploaded.
      client_max_body_size 0;
      # To disable buffering
      proxy_buffering off;
    '';
    locations."/" = {
      proxyPass = "http://127.0.0.1:9000";
      extraConfig = '''';
    };
  };
}
