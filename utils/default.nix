{
  nixpkgsUnstable,
  preCommitHooks,
  homeManager,
  doomEmacs,
  agenix,
  ...
}: let
  supportedSystems = {x86_64-linux = "x86_64-linux";};

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
          }
          (../hosts + "/${name}")
          homeManager.nixosModule
          agenix.nixosModule
          {
            home-manager.users.ccr.imports = [
              doomEmacs.hmModule
            ];
          }
        ]
        ++ modules;
      specialArgs = {
        # The following paths (../modules and ../hmModules) are relative to the location
        # where they are imported, *not* from here
        fleetModules = moduleNames: builtins.map (moduleName: ../modules + "/${moduleName}") moduleNames;
        fleetHmModules = moduleNames: builtins.map (moduleName: ../hmModules + "/${moduleName}") moduleNames;
      };
    };

  mkConfigurations = {
    pc = mkConfiguration {
      name = "pc";
      system = supportedSystems.x86_64-linux;
      modules = [];
    };
  };

  mkVmApp = system: configuration: let
    shellScript = pkgsFor.${system}.writeShellScript "run-vm" ''
      #rm ${configuration.config.networking.hostName}.qcow2
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
        src = ./.;
        hooks.alejandra.enable = true;
      };
    }
  );

  mkDevShell = lib.perSystem (system: {
    default = pkgsFor.${system}.mkShell {
      inherit (checkFormattingHook.${system}.nix) shellHook;
    };
  });
in {
  inherit lib mkConfigurations mkVmApps supportedSystems formatApp formatter mkDevShell checkFormatting;
}
