{
  description = "A complete, declarative and reproducible configuration of my entire Nix fleet";

  inputs =
    {
      stable.url = github:nixos/nixpkgs/release-21.11;
      unstable.url = github:nixos/nixpkgs/nixos-unstable;
      nixpkgsDevInput.url = github:aciceri/nixpkgs;

      nur.url = github:nix-community/NUR;

      digga.url = github:divnix/digga/hotfix-exported-overlays; # waiting for https://github.com/divnix/digga/issues/464
      digga.inputs.nixpkgs.follows = "unstable";
      digga.inputs.nixlib.follows = "unstable";
      digga.inputs.home-manager.follows = "unstable";

      home.url = github:nix-community/home-manager;
      home.inputs.nixpkgs.follows = "unstable";

      deploy.follows = "digga/deploy";

      emacs-overlay.url = github:nix-community/emacs-overlay;
      emacs-overlay.inputs.nixpkgs.follows = "unstable";

      nixos-hardware.url = github:NixOS/nixos-hardware;
    };

  outputs =
    { self
    , stable
    , unstable
    , nixpkgsDevInput
    , digga
    , home
    , nixos-hardware
    , emacs-overlay
    , nur
    , deploy
    , ...
    } @ inputs:

    digga.lib.mkFlake
      {
        inherit self inputs;

        channelsConfig = { allowUnfree = true; };

        channels = {
          stable = {
            imports = [ (digga.lib.importOverlays ./overlays) ];
          };
          unstable = {
            imports = [ (digga.lib.importOverlays ./overlays) ];
          };
        };

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
          emacs-overlay.overlay
          nur.overlay
          deploy.overlay
          (import ./pkgs {
            nixpkgsStableInput = stable;
            nixpkgsDevInput = nixpkgsDevInput;
          })
        ];

        nixos = {
          hostDefaults = {
            channelName = "stable";
            imports = [ (digga.lib.importExportableModules ./modules) ];
            modules = [
              # { lib.our = self.lib; }
              digga.nixosModules.bootstrapIso
              digga.nixosModules.nixConfig
              home.nixosModules.home-manager
            ];
          };
          hosts = {
            pc = {
              system = "x86_64-linux";
              channelName = "unstable";
              imports = [{ modules = ./hosts/pc; }];
            };
            hs = {
              system = "x86_64-linux";
              channelName = "stable";
              imports = [{ modules = ./hosts/hs; }];
            };
            pbp = {
              system = "aarch64-linux";
              channelName = "unstable";
              imports = [{ modules = ./hosts/pbp; }];
              modules = [
                "${nixos-hardware}/pine64/pinebook-pro"
              ];
            };
          };
          importables = rec {
            profiles = digga.lib.rakeLeaves ./profiles // {
              users = digga.lib.rakeLeaves ./users;
            };
            suites = with profiles; rec {
              base = [ core upower users.ccr users.root ];
            };
          };
        };

        home = {
          imports = [ (digga.lib.importExportableModules ./users/modules) ];
          modules = [ ];
          importables = rec {
            profiles = digga.lib.rakeLeaves ./users/profiles;
            suites = with profiles; rec {
              base = [ direnv git zsh gpg password-store udiskie tmux ];
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

        homeConfigurations = digga.lib.mkHomeConfigurations
          self.nixosConfigurations;

        deploy.nodes = digga.lib.mkDeployNodes
          self.nixosConfigurations
          { };
      };
}
