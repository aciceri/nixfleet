{ config, ... }:
{
  environment.persistence."/persist".directories = [
    config.services.immich.machine-learning.environment.MACHINE_LEARNING_CACHE_FOLDER
  ];

  services.immich = {
    enable = true;
    mediaLocation = "/mnt/hd/immich";
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
}
