{ pkgs, ... }:
{
  services.searx = {
    enable = true;
    package = pkgs.searxng;
    settings = {
      server.secret_key = "secret";
      search.formats = [
        "html"
        "json"
      ];
    };
  };
}
