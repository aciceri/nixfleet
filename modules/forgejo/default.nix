{
  config,
  pkgs,
  ...
}: {
  services.forgejo = {
    enable = true;
    stateDir = "/mnt/hd/forgejo";
    settings = {
      DEFAULT = {
        RUN_MODE = "dev";
        APP_NAME = "git.aciceri.dev";
      };
      session.COOKIE_SECURE = true;
      service.DISABLE_REGISTRATION = true;
      server = {
        HTTP_PORT = 3002;
        ROOT_URL = "https://git.aciceri.dev";
      };
      other = {
        SHOW_FOOTER_VERSION = false;
      };
    };
    dump.enable = true;
  };

  systemd.tmpfiles.rules = [
    "d ${config.services.forgejo.stateDir} 770 forgejo forgejo"
  ];

  backup.paths = [
    config.services.forgejo.stateDir
  ];

  imports = [../nginx-base];

  services.nginx.virtualHosts = {
    "git.aciceri.dev" = {
      enableACME = true;
      forceSSL = true;
      locations."/".proxyPass = "http://127.0.0.1:${builtins.toString config.services.forgejo.settings.server.HTTP_PORT}";
    };
  };
}
