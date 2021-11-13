{
  description = "A highly structured configuration database.";

  inputs =
    {
      stable.url = "github:nixos/nixpkgs/release-21.05";
      unstable.url = "github:nixos/nixpkgs/30aeeaded47d4e246941147acaa357d1605ad486";

      nur.url = "github:nix-community/NUR";

      digga.url = "github:divnix/digga";
      digga.inputs.nixpkgs.follows = "stable";
      digga.inputs.nixlib.follows = "stable";
      digga.inputs.home-manager.follows = "home";

      bud.url = "github:divnix/bud";
      bud.inputs.nixpkgs.follows = "unstable";
      bud.inputs.devshell.follows = "digga/devshell";

      home.url = "github:nix-community/home-manager/release-21.05";
      home.inputs.nixpkgs.follows = "stable";

      darwin.url = "github:LnL7/nix-darwin";
      darwin.inputs.nixpkgs.follows = "unstable";

      deploy.follows = "digga/deploy";

      nvfetcher.url = "github:berberman/nvfetcher";
      nvfetcher.inputs.nixpkgs.follows = "unstable";
      nvfetcher.inputs.flake-compat.follows = "digga/deploy/flake-compat";
      nvfetcher.inputs.flake-utils.follows = "digga/flake-utils-plus/flake-utils";

      emacs-overlay.url = github:nix-community/emacs-overlay;

      nixos-hardware.url = "github:nixos/nixos-hardware";

      pinebook-pro = {
        url = "github:samueldr/wip-pinebook-pro/7df87f4f3baecccba79807c291b3bbd62ac61e0f";
        flake = false;
      };
      pinebook-pro-kernel-latest.url = github:nixos/nixpkgs/755db9a1e9a35c185f7d6c0463025e94ef44622e;

      nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";
      nixpkgs-wayland.inputs.nixpkgs.follows = "unstable";
      nixpkgs-wayland.inputs.cachix.follows = "unstable";
    };

  outputs =
    { self
    , digga
    , bud
    , nixos
    , home
    , nixos-hardware
    , darwin
    , pinebook-pro
    , pinebook-pro-kernel-latest
    , nixpkgs-wayland
    , emacs-overlay
    , nur
    , nvfetcher
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
              digga.overlays.patchedNix
              nur.overlay
              emacs-overlay.overlay
              nvfetcher.overlay
              deploy.overlay
              nixpkgs-wayland.overlay
              ./pkgs/default.nix
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

        lib = import ./lib { lib = digga.lib // nixos.lib; };

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
            channelName = "unstable";
            imports = [ (digga.lib.importExportableModules ./modules) ];
            modules = [
              { lib.our = self.lib; }
              digga.nixosModules.bootstrapIso
              digga.nixosModules.nixConfig
              home.nixosModules.home-manager
              bud.nixosModules.bud
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
                "${pinebook-pro}/pinebook_pro.nix"
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
            pbpKernelLatest = (
              import pinebook-pro-kernel-latest {
                system = "aarch64-linux";
                overlays = [
                  (import "${pinebook-pro}/overlay.nix")
                ];
                config.allowUnfree = true;
              }
            ).pkgs.linuxPackages_pinebookpro_latest;
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
              browser = [ firefox chromium qutebrowser ];
              multimedia = [ mpv zathura ];
              dev = [ vim emacs vscode lorri direnv ];
            };
          };
        };

        devshell = ./shell;

        homeConfigurations = digga.lib.mkHomeConfigurations self.nixosConfigurations;

        deploy.nodes = digga.lib.mkDeployNodes self.nixosConfigurations { };

        defaultTemplate = self.templates.bud;
        templates.bud.path = ./.;
        templates.bud.description = "bud template";

      }
    // {
      budModules = { devos = import ./bud; };

      # checks.aarch64-linux = { }; # ga-uncomment
      # checks.x86_64-darwin = { }; # ga-uncomment
      # packages.x86_64-darwin = { }; # ga-uncomment

      darwinConfigurations."mbp" = darwin.lib.darwinSystem {
        system = "x86_64-darwin";
        modules = [ home.darwinModules.home-manager ./hosts/mbp ];
        inputs = { inherit darwin; };
        specialArgs = { inherit emacs-overlay; };
      };
    };
}
