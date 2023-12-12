{config, ...}: {
  services.cloudflare-dyndns = {
    enable = true;
    ipv4 = true;
    ipv6 = true;
    domains = [
      # "sevenofnix.aciceri.dev"
      "home.aciceri.dev"
      "torrent.aciceri.dev"
      "search.aciceri.dev"
      "invidious.aciceri.dev"
      "wireguard.aciceri.dev"
    ];
    apiTokenFile = config.age.secrets.cloudflare-dyndns-api-token.path;
  };
}
