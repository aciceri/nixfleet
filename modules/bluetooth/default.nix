{
  pkgs,
  config,
  lib,
  ...
}:
{
  services.blueman.enable = true;
  hardware.bluetooth = {
    enable = lib.mkDefault true;
    settings = {
      General = {
        Name = config.networking.hostName;
        ControllerMode = "dual";
        FastConnectable = "true";
        Experimental = "true";
      };
      Policy = {
        AutoEnable = "true";
      };
    };
  };
  services.dbus.packages = with pkgs; [ blueman ];
  ccr.extraGroups = [ "bluetooth" ];
}
