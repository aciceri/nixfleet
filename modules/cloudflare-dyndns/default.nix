{config, ...}: {
  services.cloudflare-dyndns = {
    enable = true;
    ipv4 = true;
    ipv6 = false; # not anymore 😭
    domains = [
      # "sevenofnix.aciceri.dev"
      "home.aciceri.dev"
      "torrent.aciceri.dev"
      "search.aciceri.dev"
      "invidious.aciceri.dev"
      "vpn.aciceri.dev"
      "cache.aciceri.dev"
    ];
    apiTokenFile = config.age.secrets.cloudflare-dyndns-api-token.path;
  };
}
