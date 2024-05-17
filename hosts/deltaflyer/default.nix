{
  fleetModules,
  config,
  lib,
  pkgs,
  fleetFlake,
  ...
}: {
  imports =
    fleetModules [
      "common"
      "ssh"
      "ccr"
      "nix"
      "bluetooth"
      "dbus"
      "networkmanager"
      "pam"
      "fonts"
      "waydroid"
      "wireguard-client"
    ]
    ++ [
      # ./mobile-nixos-branding.nix
      ./plasma-mobile.nix
    ];

  # options.home-manager.services.kanshi.attrTag = null;

  config = lib.mkMerge [
    # INSECURE STUFF FIRST
    # Users and hardcoded passwords.
    {
      users.users.root.password = "nixos";
      # users.users.ccr.password = "1234";

      # Automatically login as defaultUserName.
      # services.xserver.displayManager.autoLogin = {
      #   user = "ccr";
      # };
    }

    # Networking, modem and misc.
    {
      # Ensures any rndis config from stage-1 is not clobbered by NetworkManager
      networking.networkmanager.unmanaged = ["rndis0" "usb0"];

      # Setup USB gadget networking in initrd...
      mobile.boot.stage-1.networking.enable = lib.mkDefault true;
    }

    # SSH
    {
      # Start SSH by default...
      # Not a good idea given the fact this config is insecure (well-known password).
      services.openssh = {
        settings.PermitRootLogin = lib.mkForce "yes";
      };
      mobile.adbd.enable = true;
      ccr = {
        enable = true;
        autologin = true;
        modules = [
          "git"
          "shell"
          "helix"
          "hyprland"
          "emacs"
          "firefox"
          "mpv"
          "xdg"
        ];
        extraGroups = [
          "dialout"
          "feedbackd"
          "networkmanager"
          "video"
          "wheel"
        ];
        backupPaths = [];
      };
    }

    {
      system.stateVersion = "24.11";
      nixpkgs.config.allowUnfreePredicate = pkg:
        builtins.elem (lib.getName pkg) [
          "oneplus-sdm845-firmware-zstd"
          "oneplus-sdm845-firmware-xz"
          "oneplus-sdm845-firmware"
        ];
      nixpkgs.crossSystem = lib.mkForce null;
      nixpkgs.localSystem.system = "aarch64-linux"; # we use an aarch64 nix remote builder or binfmt
      # mobile.boot.stage-1.kernel.useStrictKernelConfig = lib.mkDefault true;

      ccr.extraModules = [
        {
          programs.fish.loginShellInit = ''
            pgrep Hypr >/dev/null || exec dbus-run-session Hyprland
          '';
          wayland.windowManager.hyprland.extraConfig = lib.mkAfter ''
            monitor = DSI-1, 1080x2340, 0x0, 2, transform, 1
            input {
              touchdevice {
                transform = 1
              }
            }
            bind = $mod, r, exec, rotate-screen hor
            bind = $mod SHIFT, r, exec, rotate-screen ver
          '';
          home.packages = let
            rotateScript = pkgs.writeShellApplication {
              name = "rotate-screen";
              runtimeInputs = [pkgs.hyprland];
              text = ''
                if [[ "$1" == "hor" ]]; then
                  hyprctl keyword monitor DSI-1,1080x2340,0x0,2,transform,1
                  hyprctl keyword input:touchdevice:transform 1
                elif [[ "$1" == "ver" ]]; then
                  hyprctl keyword monitor DSI-1,1080x2340,0x0,2,transform,0
                  hyprctl keyword input:touchdevice:transform 0
                fi
              '';
            };
          in [rotateScript];
          services.swayidle.enable = lib.mkForce false;
        }
      ];

      environment.systemPackages = [
        # (pkgs.writeShellApplication {
        #   name = "start-win98";
        #   text = fleetFlake.inputs.nixThePlanet.apps.aarch64-linux.win98.program;
        # })
        pkgs.libreoffice
        pkgs.superTuxKart
        pkgs.chromium
        pkgs.dolphin-emu
      ];

      zramSwap.enable = lib.mkDefault true;

      boot.binfmt.emulatedSystems = lib.mkForce ["x86_64-linux" "i686-linux" "i386-linux" "i486-linux" "i586-linux"];
    }
  ];
}
