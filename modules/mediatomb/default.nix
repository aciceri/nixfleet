{ pkgs, ... }:
{
  services.mediatomb = {
    enable = true;
    # FIXME remove when fixed
    package =
      (builtins.getFlake "github:NixOs/nixpkgs/3ffbbdbac0566a0977da3d2657b89cbcfe9a173b")
      .legacyPackages.${pkgs.stdenv.system}.gerbera;
    openFirewall = true;
    serverName = "Sisko";
    mediaDirectories = [
      {
        path = "/mnt/hd/torrent";
        recursive = true;
      }
    ];
  };

  users.users.mediatomb.extraGroups = [ "transmission" ];
}
