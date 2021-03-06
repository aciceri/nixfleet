{ self, config, lib, pkgs, ... }:
let
  inherit (lib) fileContents;
in
{
  imports = [ ../cachix ];

  environment = {

    systemPackages = with pkgs; [
      #skim
      bat
      bat-extras.batman
      binutils
      bottom
      coreutils
      curl
      dnsutils
      dosfstools
      fd
      git
      glances
      gptfdisk
      htop
      iputils
      jq
      lsof
      manix
      moreutils
      nix-index
      nmap
      ripgrep
      tealdeer
      usbutils
      utillinux
      whois
    ];
  };

  fonts = {
    fonts = with pkgs; [ powerline-fonts dejavu_fonts fira-code fira-code-symbols emacs-all-the-icons-fonts ];
    fontconfig.defaultFonts = {
      monospace = [ "DejaVu Sans Mono for Powerline" ];
      sansSerif = [ "DejaVu Sans" ];
    };
  };

  time.timeZone = "Europe/Rome";
  location.provider = "geoclue2";


  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDJmn7H6wxrxCHypvY74Z6pBr5G6v564NaUZb9xIILV92JEdpZzuTLLlP+JkMx/8MLRy+pC7prMwR+FhH+LaTm/9x3T6FYP/q9UIAL3cFwBAwj5XQXQKzx9f6pX/7iJrMfAUQ+ZrRUNJHt5Gl+8UypmDgnQLuv5vmQSMRzKnUPuu4lCJtWOpSPhXffz3Ec1tm5nAMuxIMRPY91PYu1fMLlFrjB1FX1goVHKB1uWx16GjJszYCVbN6xcPac0sgUg+qNGBhWkUh0F073rhepQJeWp5FtwIxe2zRsZBxxTy5qxNLmHzBeNDxlOkcy2/Lr+BxVy+mhF/2fJziX80/bWSEA1"
  ];

  nix = {
    gc.automatic = true;
    optimise.automatic = true;
    autoOptimiseStore = true;
    useSandbox = true;
    allowedUsers = [ "@wheel" ];
    trustedUsers = [ "root" "@wheel" "hydra" "hydra-www" ];
  };

  services.earlyoom.enable = true;
}
