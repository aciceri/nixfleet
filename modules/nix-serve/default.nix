{
  config,
  lib,
  ...
}: let
  cfg = config.services.my-nix-serve;
in {
  imports = [../nginx-base];
  options.services.my-nix-serve = {
    domain = lib.mkOption {
      type = lib.types.str;
      default = "cache.aciceri.dev";
    };
  };
  config = {
    services.nix-serve = {
      enable = true;
      secretKeyFile = config.age.secrets.cache-private-key.path;
      # Public key: cache.aciceri.dev:4e9sFjWPUOjGwTJE98PXinJJZLwPz0m5nKsAe63MY3E=
    };
    services.nginx.virtualHosts."${cfg.domain}" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${builtins.toString config.services.nix-serve.port}";
      };
    };
  };
}
