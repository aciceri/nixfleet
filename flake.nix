{
  description = "A highly structured configuration database.";

  inputs =
    {
      stable.url = github:nixos/nixpkgs/release-21.11;
      unstable.url = github:nixos/nixpkgs/nixos-unstable;
      nixpkgs-dev.url = github:aciceri/nixpkgs;

      nur.url = github:nix-community/NUR;

      digga.url = github:divnix/digga;
      digga.inputs.nixpkgs.follows = "unstable";
      digga.inputs.nixlib.follows = "unstable";
      digga.inputs.home-manager.follows = "unstable";

      home.url = github:nix-community/home-manager/release-21.11;
      home.inputs.nixpkgs.follows = "unstable";

      darwin.url = github:LnL7/nix-darwin;
      darwin.inputs.nixpkgs.follows = "stable";

      deploy.follows = "digga/deploy";

      emacs-overlay.url = github:nix-community/emacs-overlay/beffadfb0345078ab3d630e9ca6e0aaf061d3aa5;

      nixos-hardware.url = github:NixOS/nixos-hardware;

      nixpkgs-wayland.url = github:nix-community/nixpkgs-wayland;
      nixpkgs-wayland.inputs.nixpkgs.follows = "unstable";
      nixpkgs-wayland.inputs.cachix.follows = "unstable";
    };

  outputs =
    { self
    , digga
    , unstable
    , nixpkgs-dev
    , home
    , nixos-hardware
    , darwin
    , nixpkgs-wayland
    , emacs-overlay
    , nur
    , deploy
    , ...
    } @ inputs:

    digga.lib.mkFlake
      {
        inherit self inputs;

        channelsConfig = { allowUnfree = true; };

        channels =
          let
            commonOverlays = [
              nur.overlay
              emacs-overlay.overlay
              deploy.overlay
              #nixpkgs-wayland.overlay
              (import ./pkgs/default.nix {
                unstablePkgsInput = inputs.unstable;
              })
            ];
          in
          {
            stable = {
              imports = [ (digga.lib.importOverlays ./overlays) ];
              overlays = commonOverlays;
            };
            unstable = {
              imports = [ (digga.lib.importOverlays ./overlays) ];
              overlays = commonOverlays;
            };
          };

        lib = import ./lib { lib = digga.lib // unstable.lib; };

        sharedOverlays = [
          (
            final: prev: {
              __dontExport = true;
              lib = prev.lib.extend (
                lfinal: lprev: {
                  our = self.lib;
                }
              );
            }
          )
        ];

        nixos = {
          hostDefaults = {
            # channelName = "unstable";
            channelName = "stable";
            imports = [ (digga.lib.importExportableModules ./modules) ];
            modules = [
              { lib.our = self.lib; }
              digga.nixosModules.bootstrapIso
              digga.nixosModules.nixConfig
              home.nixosModules.home-manager
            ];
          };
          hosts = {
            # mbp is added bypassing Digga's mkFlake and adding a specific output to this flake
            pc = {
              system = "x86_64-linux";
              imports = [{ modules = ./hosts/pc; }];
            };
            hs = {
              system = "x86_64-linux";
              imports = [{ modules = ./hosts/hs; }];
            };
            pbp = {
              system = "aarch64-linux";
              imports = [{ modules = ./hosts/pbp; }];
              modules = [
                "${nixos-hardware}/pine64/pinebook-pro"
              ];
            };
          };
          # imports = [ (digga.lib.importHosts ./hosts) ]; # same reason as above
          importables = rec {
            profiles = digga.lib.rakeLeaves ./profiles // {
              users = digga.lib.rakeLeaves ./users;
            };
            suites = with profiles; rec {
              base = [ core users.ccr users.root ];
            };
            nixpkgs-dev = inputs.nixpkgs-dev.legacyPackages.aarch64-linux;
          };
        };

        home = {
          imports = [ (digga.lib.importExportableModules ./users/modules) ];
          modules = [ ];
          importables = rec {
            profiles = digga.lib.rakeLeaves ./users/profiles;
            suites = with profiles; rec {
              base = [ direnv git zsh gpg password-store ];
              emails = [ mails ];
              shell = [ zsh exa fzf ];
              gui = [ sway xdg gtk foot bat ];
              browser = [ firefox chromium qutebrowser tor-browser ];
              multimedia = [ mpv zathura ];
              dev = [ vim emacs vscode lorri direnv qmk ];
              modelling = [ blender cura ];
            };
          };
        };

        devshell = ./shell;

        homeConfigurations = digga.lib.mkHomeConfigurations self.nixosConfigurations;

        deploy.nodes = digga.lib.mkDeployNodes self.nixosConfigurations { };
      }
    // {
      # checks.aarch64-linux = { }; # ga-uncomment
      # checks.x86_64-darwin = { }; # ga-uncomment
      # packages.x86_64-darwin = { }; # ga-uncomment

      darwinConfigurations."mbp" = darwin.lib.darwinSystem {
        system = "x86_64-darwin";
        modules = [ home.darwinModules.home-manager ./hosts/mbp ];
        inputs = { inherit darwin; };
        specialArgs = {
          inherit emacs-overlay; unstablePkgsInput = inputs.unstablePkgs;
        };
      };
    };
}
