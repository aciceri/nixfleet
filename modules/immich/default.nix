# { lib, pkgs, config, ... }:
# let
#   immichRoot = "/mnt/hd/immich";
#   immichData = "${immichRoot}/data";
#   # immichVersion = "v1.105.1";
#   immichVersion = "v1.105.1";
#   sharedEnv = {
#     # You can find documentation for all the supported env variables at https://immich.app/docs/install/environment-variables
#     # The location where your uploaded files are stored
#     UPLOAD_LOCATION="./library";
#     DB_DATA_LOCATION="./postgres";
#     IMMICH_VERSION=immichVersion;
#     DB_PASSWORD="postgres";
#     DB_USERNAME="postgres";
#     DB_DATABASE_NAME="immich";
#     DB_HOSTNAME="postgres";
#     REDIS_HOSTNAME = "redis";
#   };
#   postgresRoot = "${immichRoot}/pgsql";
#   machineLearning = "${immichRoot}/ml-cache";
# in {
#   systemd.tmpfiles.rules = [
#     "d ${immichRoot} 770 ccr wheel"
#     "d ${immichData} 770 ccr wheel"
#     "d ${postgresRoot} 770 ccr wheel"
#     "d ${machineLearning} 770 ccr wheel"
#   ];
#   virtualisation.docker.enable = lib.mkForce false;
#   virtualisation.podman.enable = lib.mkForce true;
#   virtualisation.podman.dockerSocket.enable = lib.mkForce true;
#   virtualisation.podman.defaultNetwork.settings.dns_enabled = lib.mkForce true;
#   networking.firewall.interfaces."podman+".allowedUDPPorts = [53 5353];
#   environment.systemPackages = [
#     pkgs.arion
#   ];
#   virtualisation.arion = {
#     backend = lib.mkForce "podman-socket";
#     projects.immich = {
#       serviceName = "immich";
#       settings = {
# 	project.name = "immich";
# 	networks.default = {
# 	  name = "immich";
# 	};
# 	services = {
# 	  "server" = {
# 	    service = {
# 	      image = "ghcr.io/immich-app/immich-server:${immichVersion}";
# 	      container_name = "server";
# 	      command = ["start.sh" "immich"];
# 	      environment = sharedEnv // {
# 		# NODE_ENV = "production";
# 	      };
# 	      ports = [
# 		"2283:3001"
# 	      ];
# 	      volumes = [
# 		"${immichData}:/usr/src/app/upload:rw"
# 		"/etc/localtime:/etc/localtime:ro"
# 	      ];
# 	      depends_on = ["redis" "postgres"];
# 	      restart = "always";
# 	   };
# 	  };
# 	  "microservices" = {
# 	    service = {
# 	      image = "ghcr.io/immich-app/immich-server:${immichVersion}";
# 	      container_name = "microservices";
# 	      command = ["start.sh" "microservices"];
# 	      environment = sharedEnv;
# 	      volumes = ["${immichData}:/usr/src/app/upload:rw"];
# 	      depends_on = ["redis" "postgres"];
# 	      restart = "always";
# 	   };
# 	  };
# 	  "machine_learning" = {
# 	    service = {
# 	      image = "ghcr.io/immich-app/immich-machine-learning:${immichVersion}";
# 	      container_name = "machine_learning";
# 	      volumes = [
# 		"${machineLearning}:/cache"
# 	      ];
# 	      restart = "always";
# 	      environment = sharedEnv // {
# 		# NODE_ENV = "production";
# 	      };
# 	    };
# 	  };
# 	  "redis" = {
# 	    service = {
# 	      image = "docker.io/redis:6.2-alpine";
# 	      container_name = "redis";
# 	      restart = "always";
# 	      tmpfs = ["/data"];
# 	    };
# 	  };
# 	  "postgres" = {
# 	    service = {
# 	      image = "docker.io/tensorchord/pgvecto-rs:pg14-v0.2.0";
# 	      container_name = "postgres";
# 	      volumes = [
# 		"${postgresRoot}:/var/lib/postgresql/data"
# 	      ];
# 	      restart = "always";
# 	      environment = {
# 		POSTGRES_PASSWORD = sharedEnv.DB_PASSWORD;
# 		POSTGRES_USER = sharedEnv.DB_USERNAME;
# 		POSTGRES_DB = sharedEnv.DB_DATABASE_NAME;
# 		POSTGRES_INITDB_ARGS = "--data-checksums";
# 	      };
# 	    };
# 	  };
# 	};
#       };
#     };
#   };
# }
{config, ...}: let
  immichHost = "immich.example.com"; # TODO: put your immich domain name here

  immichRoot = "/mnt/hd/immich"; # TODO: Tweak these to your desired storage locations
  immichPhotos = "${immichRoot}/photos";
  immichAppdataRoot = "${immichRoot}/appdata";
  immichVersion = "release";
  # immichExternalVolume1 = "/tank/BackupData/Google Photos/someone@example.com"; # TODO: if external volumes are desired

  postgresRoot = "${immichAppdataRoot}/pgsql";
  postgresPassword = "immich"; # TODO: put a random password here
  postgresUser = "immich";
  postgresDb = "immich";
in {
  # The primary source for this configuration is the recommended docker-compose installation of immich from
  # https://immich.app/docs/install/docker-compose, which linkes to:
  # - https://github.com/immich-app/immich/releases/latest/download/docker-compose.yml
  # - https://github.com/immich-app/immich/releases/latest/download/example.env
  # and has been transposed into nixos configuration here.  Those upstream files should probably be checked
  # for serious changes if there are any upgrade problems here.
  #
  # After initial deployment, these in-process configurations need to be done:
  # - create an admin user by accessing the site
  # - login with the admin user
  # - set the "Machine Learning Settings" > "URL" to http://immich_machine_learning:3003

  virtualisation.oci-containers.containers.immich_server = {
    image = "ghcr.io/immich-app/immich-server:${immichVersion}";
    ports = ["127.0.0.1:2283:3001"];
    extraOptions = [
      "--pull=newer"
      # Force DNS resolution to only be the podman dnsname name server; by default podman provides a resolv.conf
      # that includes both this server and the upstream system server, causing resolutions of other pod names
      # to be inconsistent.
      "--dns=10.88.0.1"
    ];
    cmd = ["start.sh" "immich"];
    environment = {
      IMMICH_VERSION = immichVersion;
      DB_HOSTNAME = "immich_postgres";
      DB_USERNAME = postgresUser;
      DB_DATABASE_NAME = postgresDb;
      DB_PASSWORD = postgresPassword;
      REDIS_HOSTNAME = "immich_redis";
    };
    volumes = [
      "${immichPhotos}:/usr/src/app/upload"
      "/etc/localtime:/etc/localtime:ro"
      # "${immichExternalVolume1}:${immichExternalVolume1}:ro"
    ];
  };

  virtualisation.oci-containers.containers.immich_microservices = {
    image = "ghcr.io/immich-app/immich-server:${immichVersion}";
    extraOptions = [
      "--pull=newer"
      # Force DNS resolution to only be the podman dnsname name server; by default podman provides a resolv.conf
      # that includes both this server and the upstream system server, causing resolutions of other pod names
      # to be inconsistent.
      "--dns=10.88.0.1"
    ];
    cmd = ["start.sh" "microservices"];
    environment = {
      IMMICH_VERSION = immichVersion;
      DB_HOSTNAME = "immich_postgres";
      DB_USERNAME = postgresUser;
      DB_DATABASE_NAME = postgresDb;
      DB_PASSWORD = postgresPassword;
      REDIS_HOSTNAME = "immich_redis";
    };
    volumes = [
      "${immichPhotos}:/usr/src/app/upload"
      "/etc/localtime:/etc/localtime:ro"
      # "${immichExternalVolume}1:${immichExternalVolume1}:ro"
    ];
  };

  virtualisation.oci-containers.containers.immich_machine_learning = {
    image = "ghcr.io/immich-app/immich-machine-learning:${immichVersion}";
    extraOptions = ["--pull=newer"];
    environment = {
      IMMICH_VERSION = immichVersion;
    };
    volumes = [
      "${immichAppdataRoot}/model-cache:/cache"
    ];
  };

  virtualisation.oci-containers.containers.immich_redis = {
    image = "redis:6.2-alpine@sha256:80cc8518800438c684a53ed829c621c94afd1087aaeb59b0d4343ed3e7bcf6c5";
  };

  virtualisation.oci-containers.containers.immich_postgres = {
    image = "tensorchord/pgvecto-rs:pg14-v0.1.11";
    environment = {
      POSTGRES_PASSWORD = postgresPassword;
      POSTGRES_USER = postgresUser;
      POSTGRES_DB = postgresDb;
    };
    volumes = [
      "${postgresRoot}:/var/lib/postgresql/data"
    ];
  };
}
