{
  containers.immich = {
    nixpkgs = builtins.getFlake "github:NixOS/nixpkgs/51296fce6f2b33717f710788af4e134aa7ff0e58";
    autoStart = true;
    privateNetwork = true;
    # hostAddress = "192.168.100.10";
    # localAddress = "192.168.100.11";
    # hostAddress6 = "fc00::1";
    # localAddress6 = "fc00::2";
    config =
      {
        ...
      }:
      {
        services.immich = {
          enable = true;
        };
      };
  };
}
