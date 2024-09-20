{ config, ... }:
{
  services.tlp.enable = true;

  services.upower.enable = true;

  nixpkgs.overlays = [
    (_self: super: {
      tlp = super.tlp.override {
        enableRDW = config.networkmanager.enable;
      };
    })
  ];
}
