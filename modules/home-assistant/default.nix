{
  pkgs,
  config,
  ...
}:
let
  pun_sensor = pkgs.fetchFromGitHub {
    owner = "virtualdj";
    repo = "pun_sensor";
    rev = "51b216fab5c0d454d66060647c36e81bebfaf059";
    hash = "sha256-bGVJx3bObXdf4AiC6bDvafs53NGS2aufRcTUmXy8nAI=";
  };
  garmin_connect = pkgs.fetchFromGitHub {
    owner = "cyberjunky";
    repo = "home-assistant-garmin_connect";
    rev = "e2deaed42b66c982b150ca9a9e543031ad51228c";
    hash = "sha256-TtrcgLGnhNRBF1SqKMkPlEi/XEBUtDAnaWfzkh50+D8=";
  };
in
{
  services.home-assistant = {
    enable = true;
    openFirewall = true;
    package = pkgs.home-assistant.overrideAttrs (_old: {
      doInstallCheck = false;
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
      "wake_on_lan"
      "prometheus"
      "openai_conversation"
    ];
    customComponents = with pkgs.home-assistant-custom-components; [
      tuya_local
      localtuya
    ];
    extraPackages =
      python3Packages: with python3Packages; [
        # used by pun_sensor
        holidays
        beautifulsoup4
        tuya-device-sharing-sdk
        getmac
        garminconnect
        tzlocal
      ];
    config = {
      default_config = { };
      http = {
        use_x_forwarded_for = true;
        trusted_proxies = [
          "127.0.0.1"
          "::1"
        ];
      };
      homeassistant = {
        unit_system = "metric";
        time_zone = "Europe/Rome";
        temperature_unit = "C";
        external_url = "https://home.aciceri.dev";
        internal_url = "http://rock5b.fleet:8123";
      };
      logger.default = "WARNING";
      wake_on_lan = { };
      switch = [
        {
          name = "Picard";
          platform = "wake_on_lan";
          mac = "74:56:3c:37:17:bd"; # this shouldn't be public
          host = "picard.fleet";
          turn_off.service = "shell_command.turn_off_picard";
        }
      ];
      shell_command.turn_off_picard = ''${pkgs.openssh}/bin/ssh -i /var/lib/hass/.ssh/id_ed25519 -o StrictHostKeyChecking=no hass@picard.fleet "exec sudo \$(readlink \$(which systemctl)) poweroff"'';
      prometheus = {
        namespace = "hass";
      };
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
    "C+ ${config.services.home-assistant.configDir}/custom_components/pun_sensor 770 hass hass - ${pun_sensor}/custom_components/pun_sensor"
    "C+ ${config.services.home-assistant.configDir}/custom_components/garmin_connect 770 hass hass - ${garmin_connect}/custom_components/garmin_connect"

    "d ${config.services.home-assistant.configDir}/.ssh 770 hass hass"
    "C ${config.services.home-assistant.configDir}/.ssh/id_ed25519 700 hass hass - ${config.age.secrets.hass-ssh-key.path}"

    "d ${config.services.home-assistant.configDir}/www 770 hass hass"
    "C ${config.services.home-assistant.configDir}/www/home.png 770 hass hass - - ${config.age.secrets.home-planimetry.path}"
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
        ports = [ "10300:10300" ];
        cmd = [
          "--model"
          "medium-int8"
          "--language"
          "it"
        ];
      };
      piper = {
        image = "rhasspy/wyoming-piper:latest";
        ports = [ "10200:10200" ];
        cmd = [
          "--voice"
          "it_IT-riccardo-x_low"
        ];
      };
    };
  };

  environment.persistence."/persist".directories = [
    config.services.home-assistant.configDir
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
