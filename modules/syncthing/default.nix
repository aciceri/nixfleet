{ config, ... }:
{
  services = {
    syncthing = {
      enable = true;
      guiAddress = "${config.networking.hostName}.wg.aciceri.dev:8434";
      # TODO Use the home-manager module instead of the following conditions
      user = if config.networking.hostName == "sisko" then "syncthing" else "ccr";
      dataDir = if config.networking.hostName == "sisko" then "/mnt/hd/syncthing" else "/home/ccr";
      settings = {
        options = {
          urAccepted = 1; # anonymous usage data report
          globalAnnounceEnabled = false; # Only sync when connected to the VPN
        };
        devices = {
          picard = {
            id = "XKSCJ46-EM6GIZ7-6ABQTZZ-ZRVWVFM-MJ3QNVG-F5EWHY5-ZUNYVSL-DA77YAG";
            addresses = [
              "tcp://picard.wg.aciceri.dev"
            ];
          };
          sisko = {
            id = "QE6V7PR-VHMAHHS-GHD4ZI3-IBB7FEM-M6EQZBX-YFCWDAK-YCYL6VO-NNRMXQK";
            addresses = [
              "tcp://sisko.wg.aciceri.dev"
            ];
          };
          kirk = {
            id = "OVPXSCE-XFKCBJ2-A4SKJRI-DYBZ6CV-U2OFNA2-ALHOPW5-PPMHOIQ-5TG2HAJ";
            addresses = [
              "tcp://kirk.wg.aciceri.dev"
            ];
          };
          oneplus8t = {
            id = "KMB2YRF-DGTWU24-SLITU23-5TN7BMQ-6PFAQQZ-CZ7J2QL-PIGVBTU-VRFRMQV";
            addresses = [
              "tcp://oneplus8t.wg.aciceri.dev"
            ];
          };
        };
        folders = {
          org = {
            path =
              {
                picard = "/home/ccr/org";
                sisko = "/mnt/hd/syncthing/org";
                kirk = "/home/ccr/org";
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
                picard = "/home/ccr/sync";
                sisko = "/mnt/hd/syncthing/sync";
                kirk = "/home/ccr/sync";
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
