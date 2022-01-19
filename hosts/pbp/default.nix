{ suites, ... }:
{
  imports = [
    ./configuration.nix
  ] ++ suites.base;

  bud.enable = false;
  bud.localFlakeClone = "/home/ccr/fleet";
}
