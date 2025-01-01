{ pkgs, config, ... }:
let
  domain = "firefly.aciceri.dev";
  domainImporter = "import.firefly.aciceri.dev";
  dbUser = config.services.firefly-iii.user;
in
{
  services.firefly-iii = {
    enable = true;
    package = pkgs.firefly-iii;
    virtualHost = domain;
    enableNginx = true;
    settings = {
      APP_ENV = "production";
      APP_KEY_FILE = config.age.secrets.firefly-app-key.path;
      SITE_OWNER = "andrea.ciceri@autistici.org";
      DB_CONNECTION = "pgsql";
      DEFAULT_LANGUAGE = "en_US";
      TZ = "Europe/Rome";
    };
  };

  services.firefly-iii-data-importer = {
    enable = true;
    enableNginx = true;
    virtualHost = domainImporter;
    settings = {
      IGNORE_DUPLICATE_ERRORS = "false";
      APP_ENV = "production";
      APP_DEBUG = "false";
      LOG_CHANNEL = "stack";
      TRUSTED_PROXIES = "**";
      TZ = "Europe/Rome";
      FIREFLY_III_URL = "https://${domain}";
      VANITY_URL = "https://${domain}";
    };
  };

  imports = [ ../nginx-base ];

  services.nginx.virtualHosts = {
    ${domain} = {
      enableACME = true;
      forceSSL = true;
    };
    ${domainImporter} = {
      enableACME = true;
      forceSSL = true;
    };
  };

  services.postgresql = {
    ensureUsers = [
      {
        name = dbUser;
        ensureDBOwnership = true;
        ensureClauses.login = true;
      }
    ];
    ensureDatabases = [ dbUser ];
  };

  environment.persistence."/persist".directories = [
    config.services.firefly-iii.dataDir
    config.services.firefly-iii-data-importer.dataDir
  ];
}
