{ pkgs, ... }:
{
  home.packages = [
    (pkgs.discord.override {
      withOpenASAR = true;
      withVencord = true;
    })
  ];
  home.file.".config/discord/settings.json".text = builtins.toJSON {
    SKIP_HOST_UPDATE = true;
  };
}
