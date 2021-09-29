{ suites, ... }:
{
  imports = [
    ./configuration.nix
  ] ++ suites.base;

  bud.enable = true;
  bud.localFlakeClone = "/home/andrea/fleet";
}
