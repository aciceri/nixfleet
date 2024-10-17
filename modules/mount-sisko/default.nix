{
  pkgs,
  config,
  ...
}:
{
  environment.systemPackages = with pkgs; [ nfs-utils ];
  boot.supportedFilesystems = [ "nfs" ];
  services.rpcbind.enable = true;

  security.wrappers."mount.nfs" = {
    setuid = true;
    owner = "root";
    group = "root";
    source = "${pkgs.nfs-utils.out}/bin/mount.nfs";
  };

  fileSystems."/home/${config.ccr.username}/nas" = {
    device = "sisko.fleet:/hd";
    fsType = "nfs";
    options = [
      "x-systemd.automount"
      "noauto"
      "user"
    ];
  };
}
