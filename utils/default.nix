{
  agenix,
  comma,
  doomEmacs,
  homeManager,
  nixosHardware,
  nixpkgsUnstable,
  preCommitHooks,
  rock5b,
  self,
  ...
}: let
  supportedSystems = {
    x86_64-linux = "x86_64-linux";
    aarch64-linux = "aarch64-linux";
  };

  pkgsFor = lib.genAttrs (lib.attrValues supportedSystems) (system: nixpkgsUnstable.legacyPackages.${system});

  lib = nixpkgsUnstable.lib.extend (self: super: {
    perSystem = super.genAttrs (super.attrValues supportedSystems);
  });

  mkConfiguration = {
    name,
    system,
    modules ? [],
  }:
    lib.nixosSystem {
      inherit system;
      modules =
        [
          {
            networking.hostName = lib.mkForce name;
            home-manager.users.ccr.imports = [
              doomEmacs.hmModule
            ];
            age = {
              identityPaths = ["/home/ccr/.ssh/id_rsa"];
              secrets = lib.mapAttrs' (name: _: {
                name = lib.removeSuffix ".age" (builtins.baseNameOf name);
                value.file = ./.. + "/${name}";
              }) (import ../secrets);
            };
            nixpkgs.overlays = [agenix.overlay comma.overlays.default];
          }
          (../hosts + "/${name}")
          homeManager.nixosModule
          agenix.nixosModule
        ]
        ++ modules;
      specialArgs = {
        # The following paths (../modules and ../hmModules) are relative to the location
        # where they are imported, *not* from here
        fleetModules = moduleNames: builtins.map (moduleName: ../modules + "/${moduleName}") moduleNames;
        fleetHmModules = moduleNames: builtins.map (moduleName: ../hmModules + "/${moduleName}") moduleNames;
      };
    };

  nixosConfigurations = {
    thinkpad = mkConfiguration {
      name = "thinkpad";
      system = supportedSystems.x86_64-linux;
      modules = [nixosHardware.nixosModules.lenovo-thinkpad-x1-7th-gen];
    };
    hs = mkConfiguration {
      name = "hs";
      system = supportedSystems.x86_64-linux;
    };
    pbp = mkConfiguration {
      name = "pbp";
      system = supportedSystems.aarch64-linux;
      modules = ["${nixosHardware}/pine64/pinebook-pro"];
    };
    # Retired but it could be still usefull, so I'm not deleting it
    # beebox = mkConfiguration {
    #   name = "beebox";
    #   system = supportedSystems.x86_64-linux;
    # };
    rock5b = mkConfiguration {
      name = "rock5b";
      system = supportedSystems.aarch64-linux;
      modules = [rock5b.nixosModules.kernel rock5b.nixosModules.fan-control];
    };
  };

  mkVmApp = system: configuration: let
    shellScript = pkgsFor.${system}.writeShellScript "run-vm" ''
      ${configuration.config.system.build.vm}/bin/run-${configuration.config.networking.hostName}-vm
    '';
  in {
    type = "app";
    program = "${shellScript}";
  };

  mkVmApps = configurations:
    lib.perSystem (system:
      lib.genAttrs (lib.attrNames configurations) (
        configurationName:
          mkVmApp system configurations.${configurationName}
      ));

  formatter = lib.perSystem (system: pkgsFor.${system}.alejandra);

  formatApp = lib.perSystem (
    system: {
      format = {
        type = "app";
        program = "${pkgsFor.${system}.alejandra}/bin/alejandra";
      };
    }
  );

  checkFormatting = flakePath:
    lib.perSystem (
      system: let
        pkgs = pkgsFor.${system};
      in {
        check-nix-formatting = pkgs.runCommand "check-nix-formatting" {buildInputs = [pkgs.alejandra];} "alejandra --check ${flakePath} > $out";
      }
    );

  checkFormattingHook = lib.perSystem (
    system: {
      nix = preCommitHooks.lib.${system}.run {
        src = self;
        hooks.alejandra = {
          enable = true;
          entry = lib.mkForce formatApp.${system}.format.program;
        };
      };
    }
  );

  mkDevShell = lib.perSystem (system: let
    pkgs = pkgsFor.${system};
  in {
    default = pkgs.mkShell {
      shellHook =
        checkFormattingHook.${system}.nix.shellHook
        + ''
          export RULES="$(git rev-parse --show-toplevel)/secrets/default.nix";
        '';
      packages = with pkgs; [
        git
        agenix.packages.${system}.agenix
      ];
    };
  });
in {
  inherit
    checkFormatting
    formatApp
    formatter
    lib
    mkDevShell
    mkVmApps
    nixosConfigurations
    supportedSystems
    ;
}
