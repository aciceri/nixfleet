{ config, ... }:
let
  rev = "d531730d9640160f0519ef4b3640f8da49dd96f8";
  arbi-flake = builtins.getFlake "git+ssh://git@github.com/aciceri/arbi.git?rev=${rev}";
in
{
  imports = [ arbi-flake.nixosModules.arbi ];

  services.arbi = {
    enable = true;
    log_level = "debug";
    configFile = config.age.secrets.arbi-config.path;
  };

  environment.persistence."/persist".directories = [
    config.services.arbi.dataDir
  ];
}
