{ pkgs
, home-manager
, emacs-overlay
, unstablePkgsInput
, ...
}:
{
  imports = [
    ../../users/andreaciceri
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  nixpkgs = {
    overlays = [
      (import ../../pkgs {
        inherit unstablePkgsInput
          ;
      })
      emacs-overlay.overlay
    ];
    config.allowUnfree = true;
  };

  nix = {
    gc = {
      automatic = true;
      user = "andreaciceri";
      options = "--delete-older-than 3d";
    };
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command
      experimental-features = flakes
    '';
  };
}
