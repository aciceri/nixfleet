{ ... }:
let
  vars = {
    serviceConfigRoot = "/mnt/hd/immich/state";
    mainArray = "/mnt/hd/immich/";
    domainName = "photos.aciceri.dev";
  };
  directories = [
    "${vars.serviceConfigRoot}/immich"
    "${vars.serviceConfigRoot}/immich/postgresql"
    "${vars.serviceConfigRoot}/immich/postgresql/data"
    "${vars.serviceConfigRoot}/immich/config"
    "${vars.serviceConfigRoot}/immich/machine-learning"
    "${vars.mainArray}/Photos"
    "${vars.mainArray}/Photos/Immich"
    "${vars.mainArray}/Photos/S10m"
  ];
in
{
  systemd.tmpfiles.rules = map (x: "d ${x} 0775 root root - -") directories;
  systemd.services = {
    podman-immich = {
      requires = [
        "podman-immich-redis.service"
        "podman-immich-postgres.service"
      ];
      after = [
        "podman-immich-redis.service"
        "podman-immich-postgres.service"
      ];
    };
    podman-immich-postgres = {
      requires = [ "podman-immich-redis.service" ];
      after = [ "podman-immich-redis.service" ];
    };
  };

  virtualisation.oci-containers.containers = {
    immich = {
      autoStart = true;
      image = "ghcr.io/imagegenius/immich:latest";
      volumes = [
        "${vars.serviceConfigRoot}/immich/config:/config"
        "${vars.mainArray}/Photos/Immich:/photos"
        "${vars.mainArray}/Photos/S10m:/import:ro"
        "${vars.serviceConfigRoot}/immich/machine-learning:/config/machine-learning"
      ];
      # environmentFiles = [ config.age.secrets.ariaImmichDatabase.path ];
      environment = {
        PUID = "994";
        PGID = "993";
        TZ = "Europe/Rome";
        DB_HOSTNAME = "immich-postgres";
        DB_USERNAME = "immich";
        DB_DATABASE_NAME = "immich";
        REDIS_HOSTNAME = "immich-redis";
        DB_PASSWORD = "password";
      };
      extraOptions = [
        "--pull=newer"
        "--network=container:immich-redis"
      ];
    };

    immich-redis = {
      autoStart = true;
      image = "redis";
      extraOptions = [
        "--pull=newer"
        "-l=traefik.enable=true"
        "-l=traefik.http.routers.immich.rule=Host(`photos.${vars.domainName}`)"
        "-l=traefik.http.routers.immich.service=immich"
        "-l=traefik.http.services.immich.loadbalancer.server.port=8080"
      ];
      ports = [
        "8080:8080"
      ];
    };

    immich-postgres = {
      autoStart = true;
      image = "tensorchord/pgvecto-rs:pg14-v0.2.1";
      volumes = [
        "${vars.serviceConfigRoot}/immich/postgresql/data:/var/lib/postgresql/data"
      ];
      # environmentFiles = [ config.age.secrets.ariaImmichDatabase.path ];
      environment = {
        POSTGRES_USER = "immich";
        POSTGRES_DB = "immich";
        POSTGRES_HOST_AUTH_METHOD = "trust";
        POSTGRES_PASSWORD = "password";
      };
      extraOptions = [
        "--pull=newer"
        "--network=container:immich-redis"
      ];
    };
  };
}
