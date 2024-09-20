{ config, ... }:
{
  programs.virt-manager.enable = true;
  virtualisation.libvirtd.enable = true;
  users.users."${config.ccr.username}".extraGroups = [ "libvirtd" ];
  virtualisation.libvirtd.qemu.swtpm.enable = true;
}
