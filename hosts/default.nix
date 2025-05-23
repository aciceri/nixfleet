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
            # keep in sync with https://github.com/mobile-nixos/mobile-nixos/blob/development/npins/sources.json
            rev = "d3c42f187194c26d9f0309a8ecc469d6c878ce33";
          in
          builtins.getFlake "github:NixOS/nixpkgs/${rev}";
        extraHmModules = [
          inputs.catppuccin.homeModules.catppuccin
        ];
        vpn = {
          ip = "10.100.0.5";
          publicKey = "6bzmBx2b5yzMdW0aK0KapoBesNcxTv5+qdo+pGmG+jc=";
        };
        # homeManager = builtins.getFlake "github:nix-community/home-manager/670d9ecc3e46a6e3265c203c2d136031a3d3548e";
        extraModules = [
          (import "${inputs.mobile-nixos}/lib/configuration.nix" { device = "oneplus-fajita"; })
          inputs.catppuccin.nixosModules.catppuccin
          inputs.lix-module.nixosModules.default
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
          inputs.catppuccin.homeModules.catppuccin
        ];
        secrets = {
          "kirk-wireguard-private-key" = { };
          "chatgpt-token".owner = "ccr";
          "cachix-personal-token".owner = "ccr";
          "git-workspace-tokens".owner = "ccr";
          "autistici-password".owner = "ccr";
          "restic-hetzner-password" = { };
          "nix-netrc" = { };
        };
      };

      picard = {
        vpn = {
          ip = "10.100.0.2";
          publicKey = "O9V2PI7+vZm7gGn3f9SaTsJbVe9urf/jZkdXFz/mjVU=";
        };
        extraModules = [
          inputs.disko.nixosModules.disko
          inputs.lix-module.nixosModules.default
          inputs.lanzaboote.nixosModules.lanzaboote
          inputs.catppuccin.nixosModules.catppuccin
        ];
        extraHmModules = [
          "${inputs.homeManagerGitWorkspace}/modules/services/git-workspace.nix"
          inputs.vscode-server.nixosModules.home
          inputs.catppuccin.homeModules.catppuccin
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
          "nix-netrc" = { };
        };
      };

      sisko = {
        system = "aarch64-linux";
        nixpkgs = inputs.nixpkgsSisko;
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
          "cloudflare-api-tokens" = { };
          "restic-hetzner-password" = { };
          "hass-ssh-key".owner = "hass";
          "sisko-attic-environment-file".owner = "atticd";
          "autistici-password" = {
            # FIXME terrible, should create a third ad-hoc group
            owner = "grafana";
            group = "forgejo";
          };
          "matrix-registration-shared-secret".owner = "matrix-synapse";
          "arbi-config".owner = "arbi";
          "nix-netrc" = { };
        };
      };

      pike = {
        vpn = {
          ip = "10.100.0.8";
          publicKey = "16ctjunXCXDPLSUhocstJ9z9l45/YuJFxlLkpoxChjI=";
        };
        extraModules = [
          inputs.lix-module.nixosModules.default
          inputs.catppuccin.nixosModules.catppuccin
        ];
        extraHmModules = [
          "${inputs.homeManagerGitWorkspace}/modules/services/git-workspace.nix"
          inputs.vscode-server.nixosModules.home
          inputs.catppuccin.homeModules.catppuccin
        ];
        secrets = {
          "pike-wireguard-private-key" = { };
          "chatgpt-token".owner = "ccr";
          "cachix-personal-token".owner = "ccr";
          "git-workspace-tokens".owner = "ccr";
          "autistici-password".owner = "ccr";
          "nix-netrc" = { };
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
