{ config, pkgs, ... }:
{
  environment.persistence."/persist".directories = [
    config.services.immich.machine-learning.environment.MACHINE_LEARNING_CACHE_FOLDER
  ];

  services.immich = {
    enable = true;
    mediaLocation = "/mnt/hd/immich";
    package =
      let
        pkgsImmich =
          (builtins.getFlake "github:NixOS/nixpkgs/7fd36ee82c0275fb545775cc5e4d30542899511d")
          .legacyPackages.${pkgs.system};
      in
      pkgsImmich.immich;
  };

  # The reason for this hack is quite bad
  # Before using the NixOS module Immich was installed using Docker, for this
  # reason the paths of the images in the database looks like `/photos/...`
  # and after migrating to the NixOS module I kept getting 404s for all the
  # old pictures.
  # Frankly it seems weird that it saved the absolute paths in the DB, perhaps
  # it saves somewhere else the media location root and then merge the paths,
  # however, nevertheless I set `mediaLocation` it didn't work
  fileSystems."/photos" = {
    device = "/mnt/hd/immich/";
    fsType = "ext4";
    options = [ "bind" ];
  };

  services.nginx.virtualHosts."photos.aciceri.dev" = {
    forceSSL = true;
    enableACME = true;
    locations."/" = {
      proxyPass = "http://localhost:${builtins.toString config.services.immich.port}";
      proxyWebsockets = true;
    };
    extraConfig = ''
      client_max_body_size 50000M;
    '';
  };
}
