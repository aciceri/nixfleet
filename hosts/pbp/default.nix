{ suites, ... }:
{
  imports = [
    ./configuration.nix
  ] ++ suites.base;
}
