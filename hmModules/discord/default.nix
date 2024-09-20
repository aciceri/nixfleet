{ pkgs, ... }:
{
  home.packages = [ pkgs.discord ];
  home.file.".config/discord/settings.json".text = builtins.toJSON {
    SKIP_HOST_UPDATE = true;
  };
}
