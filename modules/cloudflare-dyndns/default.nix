{ config, ... }:
{
  services.cloudflare-dyndns = {
    enable = true;
    ipv4 = true;
    ipv6 = false; # not anymore 😭
    domains = [
      "aciceri.dev"
      "git.aciceri.dev"
      "home.aciceri.dev"
      "photos.aciceri.dev"
      "jelly.aciceri.dev"
      "matrix.aciceri.dev"
      "vpn.aciceri.dev"
    ];
    apiTokenFile = config.age.secrets.cloudflare-dyndns-api-token.path;
  };
}
