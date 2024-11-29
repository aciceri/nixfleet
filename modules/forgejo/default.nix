{
  config,
  pkgs,
  lib,
  ...
}:
let
  theme = pkgs.fetchzip {
    url = "https://github.com/catppuccin/gitea/releases/download/v1.0.1/catppuccin-gitea.tar.gz";
    hash = "sha256-et5luA3SI7iOcEIQ3CVIu0+eiLs8C/8mOitYlWQa/uI=";
    stripRoot = false;
  };
in
{
  systemd.services = {
    forgejo = {
      preStart =
        let
          inherit (config.services.forgejo) stateDir;
        in
        lib.mkAfter ''
          rm -rf ${stateDir}/custom/public/assets
          mkdir -p ${stateDir}/custom/public/assets
          ln -sf ${theme} ${stateDir}/custom/public/assets/css
        '';
    };
  };

  services.forgejo = {
    # TODO migrate to Postgres
    enable = true;
    package = pkgs.forgejo;
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
      federation.ENABLED = true;
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
      ui = {
        DEFAULT_THEME = "catppuccin-mocha-blue";
        THEMES = builtins.concatStringsSep "," (
          [ "auto,forgejo-auto,forgejo-dark,forgejo-light,arc-gree,gitea" ]
          ++ (map (name: lib.removePrefix "theme-" (lib.removeSuffix ".css" name)) (
            builtins.attrNames (builtins.readDir theme)
          ))
        );
      };
      "ui.meta" = {
        AUTHOR = "Andrea Ciceri";
        DESCRIPTION = "My personal git forge";
        KEYWORDS = "git,self-hosted,forgejo,open-source,nix,nixos";
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
