{ lib, ... }:
{
  services.macos-ventura = {
    enable = true;
    cores = 8;
    threads = 8;
    mem = "16G";
    vncListenAddr = "0.0.0.0";
    sshListenAddr = "127.0.0.1";
    extraQemuFlags = [ "-nographic" ];
    sshPort = 2022;
    vncDisplayNumber = 1; # means port 59001
    stateless = false;
    openFirewall = true;
    autoStart = false;
  };

  programs.ssh.extraConfig = lib.mkAfter ''
    Host macos-ventura
    Hostname localhost
    Port 2022
    Compression yes
  '';
}
