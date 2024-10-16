{
  config,
  ...
}:
{
  services.forgejo = {
    # TODO migrate to Postgres
    enable = true;
    settings = {
      DEFAULT = {
        RUN_MODE = "prod"; # set to prod for better logs (worse performance)
        APP_NAME = "git.aciceri.dev";
      };
      service.ENABLE_NOTIFY_MAIL = true;
      session.COOKIE_SECURE = true;
      service.DISABLE_REGISTRATION = true;
      server = {
        HTTP_PORT = 3002;
        ROOT_URL = "https://git.aciceri.dev";
      };
      mailer = {
        ENABLED = true;
        PROTOCOL = "smtp+starttls";
        SMTP_ADDR = "smtp.autistici.org";
        SMTP_PORT = 587;
        FROM = "andrea.ciceri@autistici.org";
        USER = "andrea.ciceri@autistici.org";
      };
      other = {
        SHOW_FOOTER_VERSION = false;
      };
    };
    secrets.mailer.PASSWD = config.age.secrets.autistici-password.path;
    dump.enable = true;
  };

  environment.persistence."/persist".directories = [
    config.services.forgejo.stateDir
  ];

  imports = [ ../nginx-base ];

  services.nginx.virtualHosts = {
    "git.aciceri.dev" = {
      enableACME = true;
      forceSSL = true;
      locations."/".proxyPass = "http://127.0.0.1:${builtins.toString config.services.forgejo.settings.server.HTTP_PORT}";
    };
  };
}
