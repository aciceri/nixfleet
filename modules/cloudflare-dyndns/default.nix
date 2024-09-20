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
      "torrent.aciceri.dev"
      "search.aciceri.dev"
      "invidious.aciceri.dev"
      "vpn.aciceri.dev"
      "cache.aciceri.dev"
      "matrix.aciceri.dev"
      "syncv3.matrix.aciceri.dev"
      "jellyfin.aciceri.dev"
      "photos.aciceri.dev"
      "status.aciceri.dev"
    ];
    apiTokenFile = config.age.secrets.cloudflare-dyndns-api-token.path;
  };
}
