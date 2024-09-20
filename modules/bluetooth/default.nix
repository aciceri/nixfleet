{
  pkgs,
  config,
  ...
}:
{
  services.blueman.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.bluetooth = {
    enable = true;
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
