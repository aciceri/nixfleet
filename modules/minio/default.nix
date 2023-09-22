{config, ...}: {
  imports = [../nginx-base];

  services.minio = {
    enable = true;
    rootCredentialsFile = config.age.secrets.minio-credentials.path;
    region = "eu-central-1";
  };

  services.nginx.virtualHosts."cache.aciceri.dev" = {
    forceSSL = true;
    enableACME = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:9000";
    };
  };
}
