{config, ...}: {
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
            id = "NGNL7PC-RBSW33U-OQIQDHJ-K2MHEDW-4RJ6H47-CV3YLFZ-VMIMC6A-KHQWSQN";
            addresses = [
              "tcp://sisko.fleet"
            ];
          };
        };
        folders = {
          org = {
            path =
              {
                picard = "/home/${config.ccr.username}/org";
                sisko = "/mnt/hd/org";
              }
              .${config.networking.hostName};
            devices = ["picard" "sisko"];
          };
          # "Documents" = {         # Name of folder in Syncthing, also the folder ID
          #   path = "/home/myusername/Documents";    # Which folder to add to Syncthing
          #   devices = [ "device1" "device2" ];      # Which devices to share the folder with
          # };
          # "Example" = {
          #   path = "/home/myusername/Example";
          #   devices = [ "device1" ];
          #   ignorePerms = false;  # By default, Syncthing doesn't sync file permissions. This line enables it for this folder.
          # };
        };
      };
    };
  };
}
