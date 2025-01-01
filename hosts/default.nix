{
  inputs,
  ...
}:
{
  imports = [ ./module.nix ];

  fleet = {
    darwinHosts.archer = { };

    nixOnDroidHosts.janeway = { };

    hosts = {
      deltaflyer = {
        nixpkgs =
          let
            # keep in sync with https://github.com/NixOS/mobile-nixos/blob/development/pkgs.nix
            rev = "44d0940ea560dee511026a53f0e2e2cde489b4d4";
          in
          builtins.getFlake "github:NixOS/nixpkgs/${rev}";
        extraHmModules = [
          # inputs.ccrEmacs.hmModules.default
        ];
        vpn = {
          ip = "10.100.0.5";
          publicKey = "6bzmBx2b5yzMdW0aK0KapoBesNcxTv5+qdo+pGmG+jc=";
        };
        homeManager = builtins.getFlake "github:nix-community/home-manager/670d9ecc3e46a6e3265c203c2d136031a3d3548e";
        extraModules = [
          (import "${inputs.mobile-nixos}/lib/configuration.nix" { device = "oneplus-fajita"; })
        ];
        secrets = {
          "deltaflyer-wireguard-private-key" = { };
          "chatgpt-token".owner = "ccr";
        };
      };

      kirk = {
        vpn = {
          ip = "10.100.0.3";
          publicKey = "GrCpICbC25FQ+7JXgOJ9btvZp8YI/uecyBXx9IevsBo=";
        };
        extraModules = [
          inputs.disko.nixosModules.disko
          inputs.nixosHardware.nixosModules.lenovo-thinkpad-x1-7th-gen
          inputs.lix-module.nixosModules.default
          inputs.catppuccin.nixosModules.catppuccin
        ];
        extraHmModules = [
          "${inputs.homeManagerGitWorkspace}/modules/services/git-workspace.nix"
          inputs.catppuccin.homeManagerModules.catppuccin
        ];
        secrets = {
          "kirk-wireguard-private-key" = { };
          "chatgpt-token".owner = "ccr";
          "cachix-personal-token".owner = "ccr";
          "git-workspace-tokens".owner = "ccr";
          "autistici-password".owner = "ccr";
          "restic-hetzner-password" = { };
        };
      };

      picard = {
        vpn = {
          ip = "10.100.0.2";
          publicKey = "O9V2PI7+vZm7gGn3f9SaTsJbVe9urf/jZkdXFz/mjVU=";
        };
        extraModules = [
          inputs.disko.nixosModules.disko
          inputs.nixThePlanet.nixosModules.macos-ventura
          inputs.lix-module.nixosModules.default
          inputs.lanzaboote.nixosModules.lanzaboote
          inputs.catppuccin.nixosModules.catppuccin
        ];
        extraHmModules = [
          # inputs.ccrEmacs.hmModules.default
          "${inputs.homeManagerGitWorkspace}/modules/services/git-workspace.nix"
          inputs.vscode-server.nixosModules.home
          inputs.catppuccin.homeManagerModules.catppuccin
        ];
        secrets = {
          "picard-wireguard-private-key" = { };
          "chatgpt-token".owner = "ccr";
          "cachix-personal-token".owner = "ccr";
          "git-workspace-tokens".owner = "ccr";
          "autistici-password".owner = "ccr";
          "restic-hetzner-password" = { };
          "forgejo-runners-token".owner = "nixuser";
          "forgejo-nix-access-tokens".owner = "nixuser";
        };
      };

      sisko = {
        system = "aarch64-linux";
        enableHomeManager = false;
        vpn = {
          ip = "10.100.0.1";
          publicKey = "bc5giljukT1+ChbbyTLdOfejfR3c8RZ4XoXmQM54nTY=";
        };
        extraModules = with inputs; [
          disko.nixosModules.disko
          impermanence.nixosModules.impermanence
          lix-module.nixosModules.default
        ];
        secrets = {
          "sisko-wireguard-private-key" = { };
          "home-planimetry".owner = "hass";
          "home-assistant-token".owner = "prometheus";
          "grafana-password".owner = "grafana";
          "cloudflare-dyndns-api-token" = { };
          "restic-hetzner-password" = { };
          "hass-ssh-key".owner = "hass";
          "sisko-attic-environment-file".owner = "atticd";
          "autistici-password" = {
            # FIXME terrible, should create a third ad-hoc group
            owner = "grafana";
            group = "forgejo";
          };
          "firefly-app-key".owner = "firefly-iii";
        };
      };

      tpol = {
        extraModules = with inputs; [
          lix-module.nixosModules.default
        ];
        secrets = {
          "tpol-wireguard-private-key" = { };
        };
        vpn = {
          ip = "10.100.0.7";
          publicKey = "b/Pi7koTFo5CMAAzcL2ulvQ/0dUjKzbmXpvh4Lb/Bgo=";
        };
        extraHmModulesUser = "mara";
      };
    };

    vpnExtra = {
      oneplus8t = {
        ip = "10.100.0.4";
        publicKey = "9ccx4C4xvPC6lPgTZAHDSfK4FS2BP2i4D57u9IZjw18=";
      };
      macos-ventura = {
        ip = "10.100.0.6";
        publicKey = "/Eee1V0PsjZSzj7un1NxHKtFR+TpUIgJ7VAdIAzmvzQ=";
      };
    };
  };
}
