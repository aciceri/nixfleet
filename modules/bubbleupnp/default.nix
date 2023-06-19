{
  virtualisation.oci-containers.containers = {
    bubbleupnpserver = {
      image = "bubblesoftapps/bubbleupnpserver";
      ports = ["58050:58050"];
      extraOptions = ["--network=host" "-device /dev/dri:/dev/dri"];
    };
  };

  networking.firewall.allowedTCPPorts = [58050];
}
