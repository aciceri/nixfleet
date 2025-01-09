{ pkgs, ... }:
{
  sound.enable = true;

  users.extraUsers.ccr.extraGroups = [ "audio" ];
}
