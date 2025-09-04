{ config, ... }:
{
  services.trilium-server = {
    enable = true;
    dataDir = "/mnt/hd/trilium";
    nginx = {
      hostName = "trilium.sisko.wg.aciceri.dev";
      enable = true;
    };
  };

  systemd.tmpfiles.rules = [
    "d ${config.services.trilium-server.dataDir} 770 trilium trilium"
  ];

  services.nginx.virtualHosts."trilium.sisko.wg.aciceri.dev" = {
    forceSSL = true;
    useACMEHost = "aciceri.dev";
    serverAliases = [ "trilium.sisko.zt.aciceri.dev" ];
  };
}
