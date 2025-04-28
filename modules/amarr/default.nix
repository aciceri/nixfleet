args@{ lib, pkgs, ... }:
let
  pkgs = builtins.getFlake "github:NixOS/nixpkgs/d278c7bfb89130ac167e80d2250f9abc0bede419";
  amarr = pkgs.legacyPackages.${args.pkgs.system}.amarr;
in
{
  systemd.services.amarr = {
    description = "amarr";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig = {
      User = "root";
      Type = "oneshot";
      ExecStart = lib.getExe amarr;
    };
    environment = {
      AMULE_HOST = "localhost";
      AMULE_PORT = "4712";
      AMULE_PASSWORD = "";
    };
  };

}
