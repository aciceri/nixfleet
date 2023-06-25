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
      # Public key: cache.aciceri.dev-1:aNP6f+rRTuDHi/45L1VBzlGchuj54/mI2N/22qTWgzE=
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
