{
  modulesPath,
  fleetModules,
  lib,
  pkgs,
  ...
}:
{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
      (modulesPath + "/profiles/qemu-guest.nix")
    ]
    ++ fleetModules [
      "common"
      "ssh"
      "ccr"
      "nix"
    ];

  ccr = {
    enable = true;
    autologin = true;
    modules = [
      # "emacs"
      "git"
      "gpg"
      "helix"
      "password-store"
      "shell"
      "xdg"
      "git-workspace"
    ];
    packages = with pkgs; [
      comma
    ];
    extraGroups = [
      "wheel"
      "fuse"
      "video"
      "networkmanager"
    ];
  };

  fonts = {
    fonts = with pkgs; [
      powerline-fonts
      dejavu_fonts
      fira-code
      fira-code-symbols
      emacs-all-the-icons-fonts
      nerdfonts
      joypixels
      etBook
    ];
    fontconfig.defaultFonts = {
      monospace = [ "DejaVu Sans Mono for Powerline" ];
      sansSerif = [ "DejaVu Sans" ];
      serif = [ "DejaVu Serif" ];
    };
  };

  nixpkgs.config.joypixels.acceptLicense = true;

  environment.systemPackages = with pkgs; [
    waypipe
    firefox
  ];

  programs.mosh.enable = true;

  disko.devices = import ./disko.nix {
    inherit lib;
  };

  boot.loader.grub = {
    devices = [ "/dev/sda" ];
    efiSupport = true;
    efiInstallAsRemovable = true;
  };
}
