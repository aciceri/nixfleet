{config, ...}: {
  services.tlp.enable = true;

  services.upower.enable = true;

  nixpkgs.overlays = [
    (self: super: {
      tlp = super.tlp.override {
        enableRDW = config.networkmanager.enable;
      };
    })
  ];
}
