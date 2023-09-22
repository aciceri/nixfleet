{
  pkgs,
  config,
  ...
}: {
  nixpkgs.overlays = [
    (self: super: {
      grocy = super.grocy.overrideAttrs (old: {
        meta.broken = false;
        version = "4.0.1";
        src = pkgs.fetchFromGitHub {
          owner = "grocy";
          repo = "grocy";
          rev = "v4.0.1";
          hash = "sha256-bCUH2dRCSNkpWyUxGdTdjgVsagbBghcHsBX01+NuHGc=";
        };
      });
    })
  ];
  services.grocy = {
    enable = true;
    hostName = "grocy.aciceri.dev";
    nginx.enableSSL = false;
    settings = {
      culture = "it";
      currency = "EUR";
      calendar = {
        firstDayOfWeek = 1;
        showWeekNumber = true;
      };
    };
  };
  services.nginx.virtualHosts.${config.services.grocy.hostName}.listen = [
    {
      addr = "0.0.0.0";
      port = 6789;
      ssl = false;
    }
  ];
  networking.firewall.interfaces."wg0" = {
    allowedTCPPorts = [
      6789
    ];
  };
}
