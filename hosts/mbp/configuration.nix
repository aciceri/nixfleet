{ pkgs, home-manager, emacs-overlay, ... }:
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
    overlays = [ (import ../../pkgs) emacs-overlay.overlay ];
    config.allowUnfree = true;
  };

  nix = {
    package = pkgs.nixUnstable;
    gc = {
      automatic = true;
      user = "andreaciceri";
      options = "--delete-older-than 3d";
    };
  };
}
