{
  config,
  fleetFlake,
  pkgs,
  lib,
  ...
}: let
  typesenseApiKeyFile = pkgs.writeText "typesense-api-key" "12318551487654187654"; # api key not ime, stolen from upstram PR
  pkgsImmich = fleetFlake.inputs.nixpkgsImmich.legacyPackages.${pkgs.system}.extend (final: prev: {
    python = prev.python.override {
      packageOverrides = final: prev: {
        insightface = prev.insightface.overrideAttrs (_: {
          pythonCatchConflictsPhase = "";
        });
      };
    };
  });
in {
  imports = ["${fleetFlake.inputs.nixpkgsImmich}/nixos/modules/services/web-apps/immich.nix"];

  services.immich = {
    package = pkgsImmich.immich;
    enable = true;
    server.mediaDir = "/mnt/hd/immich";
    server.typesense.apiKeyFile = typesenseApiKeyFile;
  };

  services.typesense = {
    enable = true;
    # In a real setup you should generate an api key for immich
    # and not use the admin key!
    apiKeyFile = typesenseApiKeyFile;
    settings.server.api-address = "127.0.0.1";
  };

  systemd.tmpfiles.rules = [
    "d /mnt/hd/immich 770 immich immich"
  ];

  # networking.firewall.allowedTCPPorts = [8080];
  #   virtualisation.oci-containers.containers.immich = {
  #     image = "ghcr.io/imagegenius/immich:latest";
  #     extraOptions = ["--network=host"];
  #     volumes = [
  #       "/mnt/immich/photos:/photos"
  #       "/mnt/immich/config:/config"
  #     ];
  #     environment = {
  #       PUID=builtins.toString config.users.users.ccr.uid;
  #       PGID=builtins.toString config.users.groups.wheel.gid;
  #       TZ="Europe/Rome";
  #       DB_HOSTNAME="localhost";
  #       DB_USERNAME="postgres";
  #       DB_PASSWORD="postgres";
  #       DB_DATABASE_NAME="immich";
  #       DB_PORT="54320";
  #       REDIS_HOSTNAME="localhost";
  #       DISABLE_MACHINE_LEARNING="false";
  #       DISABLE_TYPESENSE="false";
  #     };
  #   };

  #   virtualisation.oci-containers.containers.immich-redis = {
  #     image = "redis";
  #     extraOptions = ["--network=host"];
  #   };

  # virtualisation.oci-containers.containers.immich-postgres = {
  #   image = "postgres:14";
  #   extraOptions = ["--network=host"];
  #   environment = {
  #     POSTGRES_USER = "postgres";
  #     POSTGRES_PASSWORD = "postgres";
  #     POSTGRES_DB = "immich";
  #     PGPORT = "54320";
  #   };
  # volumes = [
  #   "/mnt/immich/postgres:/var/lib/postgresql/data"
  # ];
  # };
}
