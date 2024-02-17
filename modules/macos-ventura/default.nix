{fleetFlake, ...}: {
  services.macos-ventura = {
    enable = true;
    cores = 8;
    threads = 8;
    mem = "8G";
    vncListenAddr = "0.0.0.0";
    extraQemuFlags = ["-nographic"];
    sshPort = 2021;
    installNix = true;
    stateless = true;
    darwinConfig = fleetFlake.darwinConfigurations.archer;
  };
}
