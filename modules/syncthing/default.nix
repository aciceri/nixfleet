{ config, ... }:
{
  services = {
    syncthing = {
      enable = true;
      guiAddress = "${config.networking.hostName}.fleet:8434";
      user = config.ccr.username;
      dataDir = "/home/${config.ccr.username}";
      settings = {
        options = {
          urAccepted = 1; # anonymous usage data report
          globalAnnounceEnabled = false; # Only sync on the VPN
        };
        devices = {
          picard = {
            id = "XKSCJ46-EM6GIZ7-6ABQTZZ-ZRVWVFM-MJ3QNVG-F5EWHY5-ZUNYVSL-DA77YAG";
            addresses = [
              "tcp://picard.fleet"
            ];
          };
          sisko = {
            id = "L5RAQXR-6U3ANNK-UJJ5AVN-37VKQRB-UK6HXSU-NN3V6HF-JNZEVA5-NI6UEAP";
            addresses = [
              "tcp://sisko.fleet"
            ];
          };
          kirk = {
            id = "OVPXSCE-XFKCBJ2-A4SKJRI-DYBZ6CV-U2OFNA2-ALHOPW5-PPMHOIQ-5TG2HAJ";
            addresses = [
              "tcp://kirk.fleet"
            ];
          };
          oneplus8t = {
            id = "76BJ2ZE-FPFDWUZ-3UZIENZ-TS6YBGG-EZSF6UE-GLHRBQ2-KTHTRMI-3JWNRAT";
            addresses = [
              "tcp://oneplus8t.fleet"
            ];
          };
        };
        folders = {
          org = {
            path =
              {
                picard = "/home/${config.ccr.username}/org";
                sisko = "/home/${config.ccr.username}/org";
                kirk = "/home/${config.ccr.username}/org";
              }
              .${config.networking.hostName};
            devices = [
              "picard"
              "sisko"
              "kirk"
              "oneplus8t"
            ];
          };
          sync = {
            path =
              {
                picard = "/home/${config.ccr.username}/sync";
                sisko = "/home/${config.ccr.username}/sync";
                kirk = "/home/${config.ccr.username}/sync";
              }
              .${config.networking.hostName};
            devices = [
              "picard"
              "sisko"
              "kirk"
            ];
          };
        };
      };
    };
  };
}
