{ config, pkgs, ... }:
let
  rev = "966199fe1dccc9c6c7016bdb1d9582f27797bc02";
  amule-flake = builtins.getFlake "github:NixOS/nixpkgs/${rev}";
  inherit (amule-flake.legacyPackages.${pkgs.system}) amule-daemon amule-web;
in
{
  disabledModules = [ "services/networking/amuled.nix" ];
  documentation.nixos.enable = false;

  imports = [ "${amule-flake}/nixos/modules/services/networking/amuled.nix" ];

  services.amule = {
    enable = true;
    package = amule-daemon;
    amuleWebPackage = amule-web;
    openPeerPorts = true;
    openWebServerPort = true;
    # TODO the service is accessible only from the VPN
    # however better using agenix
    ExternalConnectPasswordFile = pkgs.writeText "password" "pippo";
    WebServerPasswordFile = pkgs.writeText "password" "pippo";
    settings = {
      eMule = {
        IncomingDir = "/mnt/hd/amule";
        TempDir = "/mnt/hd/amule/Temp";
      };
      WebServer = {
        Enabled = 1;
      };
    };
  };

  environment.persistence."/persist".directories = [
    config.services.amule.dataDir
  ];

  services.nginx.virtualHosts."amule.sisko.wg.aciceri.dev" = {
    forceSSL = true;
    useACMEHost = "aciceri.dev";
    locations."/" = {
      proxyPass = "http://localhost:${builtins.toString config.services.amule.settings.WebServer.Port}";
    };
    serverAliases = [ "amule.sisko.zt.aciceri.dev" ];
  };
}
