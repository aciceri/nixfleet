{
  config,
  options,
  lib,
  ...
}: {
  system.autoUpgrade = {
    enable = true;
    flake = "github:aciceri/nixfleet#${config.networking.hostName}";
    flags =
      lib.lists.optional
      (builtins.hasAttr "ccrEmacs" options)
      ["--update-input" "ccrEmacs" "ccrEmacs"];
    dates = "daily";
    allowReboot = false;
  };
}
