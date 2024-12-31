{
  config,
  lib,
  pkgs,
  ...
}:
let
  clientConfig = {
    "m.homeserver".base_url = "https://matrix.aciceri.dev";
    "org.matrix.msc3575.proxy".url = "https://syncv3.matrix.aciceri.dev";
  };
  serverConfig."m.server" = "matrix.aciceri.dev:443";
  mkWellKnown = data: ''
    default_type application/json;
    add_header Access-Control-Allow-Origin *;
    return 200 '${builtins.toJSON data}';
  '';
in
{
  imports = [ ../nginx-base ];

  services.nginx.virtualHosts = {
    "aciceri.dev" = {
      enableACME = true;
      forceSSL = true;
      locations."= /.well-known/matrix/server".extraConfig = mkWellKnown serverConfig;
      locations."= /.well-known/matrix/client".extraConfig = mkWellKnown clientConfig;
    };
    "matrix.aciceri.dev" = {
      forceSSL = true;
      enableACME = true;
      locations."/".proxyPass =
        "http://127.0.0.1:${builtins.toString (lib.head config.services.matrix-synapse.settings.listeners).port}";
      locations."/_matrix".proxyPass = "http://localhost:8008";
      locations."/_synapse/client".proxyPass = "http://localhost:8008";
    };
  };

  services.postgresql = {
    enable = true;
    initialScript = pkgs.writeText "synapse-init.sql" ''
      CREATE ROLE "matrix-synapse" WITH LOGIN PASSWORD 'synapse';
      CREATE DATABASE "matrix-synapse" WITH OWNER "matrix-synapse"
        TEMPLATE template0
        LC_COLLATE = "C"
        LC_CTYPE = "C";
    '';
  };

  systemd.tmpfiles.rules = [
    "d ${config.services.matrix-synapse.dataDir} 770 matrix-synapse matrix-synapse"
  ];

  services.matrix-synapse = {
    enable = true;
    dataDir = "/mnt/hd/matrix-synapse";
    configureRedisLocally = true;
    settings = {
      server_name = "aciceri.dev";
      public_baseurl = "https://matrix.aciceri.dev";
      listeners = [
        {
          port = 8008;
          bind_addresses = [ "127.0.0.1" ];
          type = "http";
          tls = false;
          x_forwarded = true;
          resources = [
            {
              names = [
                "client"
                "federation"
              ];
              compress = true;
            }
          ];
        }
      ];
    };
    extraConfigFiles = [ config.age.secrets.matrix-registration-shared-secret.path ];
  };

  backup.paths = [
    config.services.matrix-synapse.dataDir
    "/var/backup/postgresql/matrix-synapse.sql.gz"
  ];

  services.postgresqlBackup = {
    enable = true;
    databases = [ "matrix-synapse" ];
  };

  services.matrix-sliding-sync = {
    enable = true;
    environmentFile = config.age.secrets.matrix-sliding-sync-secret.path;
    settings = {
      SYNCV3_SERVER = "http://localhost:8008";
    };
  };

  services.nginx.virtualHosts."syncv3.matrix.aciceri.dev" = {
    enableACME = true;
    forceSSL = true;
    locations."/".proxyPass = config.services.matrix-sliding-sync.settings.SYNCV3_SERVER;
  };
}
