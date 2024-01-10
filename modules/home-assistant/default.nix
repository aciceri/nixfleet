{
  pkgs,
  config,
  ...
}: let
  smartthings-fork = pkgs.fetchFromGitHub {
    owner = "veista";
    repo = "smartthings";
    rev = "ba1a6f33c6ac37d81f4263073571628803e79697";
    sha256 = "sha256-X3SYkg0B5pzEich7/4iUmlADJneVuT8HTVnIiC7odRE=";
  };
  pun_sensor = pkgs.fetchFromGitHub {
    owner = "virtualdj";
    repo = "pun_sensor";
    rev = "19f270b353594ab536f9dc42adf31427e7a81562";
    hash = "sha256-3pL+8CXzjmR54Ff9qLhHzC/C+uns0qWEgJFHv+K4MFs=";
  };
  cozy_life = pkgs.fetchFromGitHub {
    owner = "yangqian";
    repo = "hass-cozylife";
    rev = "9a40a2fa09b0f74aee0b278e2858f5600b3487a9";
    hash = "sha256-i+82EUamV1Fhwhb1vhRqn9aA9dJ0FxSSMD734domyhw=";
  };
  localtuya = pkgs.fetchFromGitHub {
    owner = "rospogrigio";
    repo = "localtuya";
    rev = "f06e4848e67997edfa696aa9a89372fb17077bd0";
    hash = "sha256-hA/1FxH0wfM0jz9VqGCT95rXlrWjxV5oIkSiBf0G0ac=";
  };
in {
  services.home-assistant = {
    enable = true;
    openFirewall = true;
    package = pkgs.home-assistant.overrideAttrs (old: {
      # doInstallCheck = false;
      # prePatch =
      #   ''
      #     rm -rf homeassistant/components/smartthings
      #     cp -r ${smartthings-fork}/custom_components/smartthings homeassistant/components/smartthings
      #   ''
      #   + old.prePatch;
    });
    extraComponents = [
      # components required to complete the onboarding
      # "esphome"
      "met"
      "radio_browser"
      "frontend"
      "cloud"
      "google_translate"
      "smartthings" # samsung devices
      "tuya"
      "timer"
      "cast"
      "weather"
      "backup"
      "brother"
      "webostv"
      "media_player"
      "wyoming"
    ];
    extraPackages = python3Packages:
      with python3Packages; [
        # used by pun_sensor
        holidays
        beautifulsoup4
      ];
    config = {
      default_config = {};
      http = {
        use_x_forwarded_for = true;
        trusted_proxies = ["127.0.0.1" "::1"];
      };
      # ffmpeg = {};
      # camera = [
      #   {
      #     name = "EyeToy";
      #     platform = "ffmpeg";
      #     input = "/dev/video1";
      #     extra_arguments = "-vcodec h264";
      #   }
      # ];
      homeassistant = {
        unit_system = "metric";
        time_zone = "Europe/Rome";
        temperature_unit = "C";
        external_url = "https://home.aciceri.dev";
        internal_url = "http://rock5b.fleet:8123";
      };
      logger.default = "WARNING";
      # backup = {};
      # media_player = [{
      #   platform = "webostv";
      #   host = "10.1.1.213";
      #   name = "TV";
      #   timeout = "5";
      #   turn_on_action = {
      #     service = "wake_on_lan.send_magic_packet";
      #     data.mac = "20:28:bc:74:14:c2";
      #   };
      # }];
    };
  };

  # services.avahi.enable = true;
  # services.avahi.nssmdns = true;

  # systemd.services.home-assistant.serviceConfig = {
  #   SupplementaryGroups = ["video"];
  #   DeviceAllow = ["/dev/video1"];
  # };
  # users.users.hass.extraGroups = ["video"];

  systemd.tmpfiles.rules = [
    "d ${config.services.home-assistant.configDir}/custom_components 770 hass hass"
    "L+ ${config.services.home-assistant.configDir}/custom_components/pun_sensor - - - - ${pun_sensor}/custom_components/pun_sensor"
    "L+ ${config.services.home-assistant.configDir}/custom_components/cozy_life - - - - ${cozy_life}/custom_components/cozylife"
    "L+ ${config.services.home-assistant.configDir}/custom_components/localtuya - - - - ${localtuya}/custom_components/localtuya"
    "d ${config.services.home-assistant.configDir}/www 770 hass hass"
    "C ${config.services.home-assistant.configDir}/www/home.png - - - - ${config.age.secrets.home-planimetry.path}"
  ];

  networking.firewall.interfaces."wg0" = {
    allowedTCPPorts = [
      config.services.home-assistant.config.http.server_port
      56000
    ];
  };

  # virtualisation.oci-containers.containers = {
  #   cam2ip = {
  #     image = "gen2brain/cam2ip:arm";
  #     ports = ["56000:56000"];
  #     extraOptions = [ "--device=/dev/video1:/dev/video1"];
  #     environment.CAM2IP_INDEX = "1";
  #   };
  # };

  virtualisation.oci-containers = {
    containers = {
      whisper = {
        image = "rhasspy/wyoming-whisper:latest";
        ports = ["10300:10300"];
        cmd = [
          "--model"
          "medium-int8"
          "--language"
          "it"
        ];
      };
      piper = {
        image = "rhasspy/wyoming-piper:latest";
        ports = ["10200:10200"];
        cmd = [
          "--voice"
          "it_IT-riccardo-x_low"
        ];
      };
    };
  };

  backup.paths = [
    "/var/lib/hass"
  ];

  # virtualisation.oci-containers = {
  #   backend = "podman";
  #   containers.homeassistant = {
  #     volumes = [ "home-assistant:/config" ];
  #     environment.TZ = "Europe/Rome";
  #     image = "ghcr.io/home-assistant/home-assistant:stable"; # Warning: if the tag does not change, the image will not be updated
  #     extraOptions = [
  #       "--network=host"
  #       "--device=/dev/ttyACM0:/dev/ttyACM0"  # Example, change this to match your own hardware
  #     ];
  #   };
  # };s
}
