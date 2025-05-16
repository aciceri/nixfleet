{
  pkgs,
  ...
}:
let
  dump1090-flake = builtins.getFlake "github:NixOS/nixpkgs/541f05042033467730fb8cedb08355dc91b94c74";
  inherit (dump1090-flake.legacyPackages.${pkgs.system}) dump1090-fa;
in
{
  imports = [ "${dump1090-flake}/nixos/modules/services/misc/dump1090-fa.nix" ];

  hardware.rtl-sdr.enable = true;

  disabledModules = [ "services/misc/dump10190-fa.nix" ];
  documentation.nixos.enable = false;

  services.dump1090-fa = {
    enable = true;
    package = dump1090-fa;
  };

  services.nginx.virtualHosts."dump1090.sisko.wg.aciceri.dev" = {
    forceSSL = true;
    useACMEHost = "aciceri.dev";
    locations = {
      "/".alias = "${dump1090-fa}/share/dump1090/";
      "/data/".alias = "/run/dump1090-fa/";
    };
    serverAliases = [ "dump1090.sisko.zt.aciceri.dev" ];
  };
}
