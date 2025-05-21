{ pkgs, lib, ... }:
{
  home.packages = [ pkgs.unison ];
  services.unison = {
    enable = true;
    pairs = {
      "roam" = {
        roots = [
          # Pair of roots to synchronize
          "/home/ccr/roam"
          "ssh://root@sisko.wg.aciceri.dev//mnt/hd/roam"
        ];
        commandOptions = {
          auto = "true";
          batch = "true";
          log = "false";
          repeat = "watch";
          sshcmd = lib.getExe pkgs.openssh;
          ui = "text";
        };
      };
    };
  };
}
