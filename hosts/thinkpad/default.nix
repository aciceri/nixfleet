{
  config,
  lib,
  pkgs,
  fleetModules,
  ...
}: {
  imports =
    [
      ./zfs.nix
      ./hardware-configuration.nix
    ]
    ++ fleetModules [
      "adb"
      "audio"
      "battery"
      # "binfmt"
      "bluetooth"
      "ccr"
      "common"
      "dbus"
      "docker"
      "fonts"
      "fprintd"
      "printing"
      "qmk-udev"
      "ssh"
      "transmission"
      "udisks2"
      "xdg"
      "nix-development"
      "clamav"
    ];

  ccr = {
    enable = true;
    autologin = true;
    modules = [
      "cura"
      "digikam"
      "discord"
      "element"
      "email"
      "emacs"
      "firefox"
      "git"
      "gpg"
      "helix"
      "mopidy"
      "mpv"
      "openscad"
      "password-store"
      "qutebrowser"
      "shell"
      "slack"
      "sway"
      "udiskie"
      "vscode"
      "xdg"
      "zathura"
      "chrome"
      "obs-studio"
      "spotify"
      "steam-run"
      "lutris"
      "wine"
    ];
    packages = with pkgs; [
      comma
    ];
    extraGroups = [
      "wheel"
      "fuse"
      "video"
      "adbusers"
      "docker"
      "networkmanager"
      "dialout"
      "bluetooth"
      "camera"
    ];
  };

  boot.initrd.availableKernelModules = ["xhci_pci" "nvme" "usb_storage" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-intel"];
  boot.extraModulePackages = with config.boot.kernelPackages; [v4l2loopback];
  boot.kernelPackages = pkgs.linuxPackages_zen;

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  #networking.interfaces.enp0s31f6.useDHCP = lib.mkDefault true;
  #networking.interfaces.wlp0s20f3.useDHCP = lib.mkDefault true;

  networking.hostName = "thinkpad"; # Define your hostname.
  # Pick only one of the below networking options.
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    #   keyMap = "us";
    useXkbConfig = true; # use xkbOptions in tty.
  };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = {
  #   "eurosign:e";
  #   "caps:escape" # map caps to escape.
  # };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  #Define a user account. Don't forget to set a password with ‘passwd’.
  #users.users.jane = {
  #  isNormalUser = true;
  #  extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  #   packages = with pkgs; [
  #     firefox
  #     thunderbird
  #   ];
  # };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    networkmanager
    wget
  ];

  programs.light.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ 5000];
  # networking.firewall.allowedUDPPorts = [ 5000 ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

  hardware.opengl = {
    enable = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      intel-media-driver
      mesa
      vulkan-loader
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
    ];
  };

  users.groups.input.members = ["ccr"];
  services.udev.extraRules = ''
    Sunshine
    KERNEL=="uinput", GROUP="input", MODE="0660", OPTIONS+="static_node=uinput"
  '';
}
