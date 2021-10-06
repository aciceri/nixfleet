{pkgs, home-manager, ...}:
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

  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes flakes ca-references
      keep-derivations = true
      keep-outputs = true
    '';
    gc = {
      automatic = false;
      user = "andreaciceri";
      options = "--delete-older-than 3d";
    };
  };
  }
