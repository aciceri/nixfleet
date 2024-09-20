{
  pkgs,
  ...
}:
{
  # nixpkgs.config.pulseaudio = true;
  # services.xrdp = {
  #   enable = true;
  #   defaultWindowManager = "xfce-session";
  # };
  # services.xserver = {
  #   enable = true;
  #   desktopManager = {
  #     xterm.enable = false;
  #     xfce.enable = true;
  #   };
  #   displayManager.defaultSession = "xfce";
  # };
  environment.systemPackages = with pkgs; [
    sunshine
    superTuxKart
  ];

  boot.kernelModules = [ "uinput" ];

  users.groups.input.members = [ "ccr" ];

  services.udev.extraRules = ''
    KERNEL=="uinput", SUBSYSTEM=="misc", OPTIONS+="static_node=uinput", TAG+="uaccess"' |
  '';
}
