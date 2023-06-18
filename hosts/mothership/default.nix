{
  # modulesPath,
  fleetModules,
  lib,
  pkgs,
  config,
  ...
}: {
  imports = fleetModules [
    "common"
    "wireguard-server"
    "ssh"
    "mosh"
    "ccr"
    "nix"
    # "vm-sala"
    "vm-mara"
    # "hydra"
    "hercules-ci"
    "nix-serve"
    "cgit"
    "docker"
    # "binfmt"
  ];

  ccr = {
    enable = true;
    autologin = true;
    modules = [
      # "emacs"
      "git"
      "gpg"
      "helix"
      "shell"
      "xdg"
      "git-workspace"
      "firefox" # used with waypipe
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

  disko.devices = import ./disko.nix {
    inherit lib;
  };

  fonts = {
    fonts = with pkgs; [powerline-fonts dejavu_fonts fira-code fira-code-symbols emacs-all-the-icons-fonts nerdfonts joypixels etBook];
    fontconfig.defaultFonts = {
      monospace = ["DejaVu Sans Mono for Powerline"];
      sansSerif = ["DejaVu Sans"];
      serif = ["DejaVu Serif"];
    };
  };

  nixpkgs.config.joypixels.acceptLicense = true;

  environment.systemPackages = with pkgs; [waypipe];

  home-manager.users.ccr.gtk = {
    enable = true;
    iconTheme = {
      name = "Adwaita";
      package = pkgs.gnome.adwaita-icon-theme;
    };
  };
  programs.dconf.enable = true;

  programs.mosh.enable = true;

  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "nvme" "usbhid"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-intel"];
  boot.extraModulePackages = [];

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 20;
  };
  networking.hostId = "03259b66";

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
