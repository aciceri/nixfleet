{
  self,
  lib,
  config,
  inputs,
  ...
}: {
  imports = [./module.nix];

  fleet = {
    hosts = {
      # thinkpad = {
      #   extraModules = with inputs; [
      #     nixosHardware.nixosModules.lenovo-thinkpad-x1-7th-gen
      # 	buildbot-nix.nixosModules.buildbot-master
      # 	buildbot-nix.nixosModules.buildbot-worker
      #   ];
      #   extraHmModules = with inputs; [
      #     ccrEmacs.hmModules.default
      #     {
      #         # TODO: remove after https://github.com/nix-community/home-manager/pull/3811
      #       imports = let
      #         hmModules = "${inputs.homeManagerGitWorkspace}/modules";
      #       in [
      #         "${hmModules}/services/git-workspace.nix"
      #       ];
      #     }
      #   ];
      #   overlays = [inputs.nil.overlays.default];
      #   secrets = {
      #     "thinkpad-wireguard-private-key" = {};
      #     "cachix-personal-token".owner = "ccr";
      #     "autistici-password".owner = "ccr";
      #     "git-workspace-tokens".owner = "ccr";
      #     "chatgpt-token".owner = "ccr";
      #   };
      # };
      # rock5b = {
      #   system = "aarch64-linux";
      #   extraModules = with inputs; [
      #     disko.nixosModules.disko
      #     rock5b.nixosModules.default
      #   ];
      #   secrets = {
      #     "rock5b-wireguard-private-key" = {};
      #     "hercules-ci-join-token".owner = "hercules-ci-agent";
      #     "hercules-ci-binary-caches".owner = "hercules-ci-agent";
      #     "cachix-personal-token".owner = "ccr";
      #     "home-planimetry".owner = "hass";
      # 	"cloudflare-dyndns-api-token" = {};
      #       # "nextcloud-admin-pass".owner = "nextcloud";
      #       # "aws-credentials" = {};
      #   };
      #   colmena.deployment.buildOnTarget = true;
      # };
      # pbp = {
      #   system = "aarch64-linux";
      #   extraModules = with inputs; [
      #     nixosHardware.nixosModules.pine64-pinebook-pro
      #     disko.nixosModules.disko
      #   ];
      #   extraHmModules = [
      #     inputs.ccrEmacs.hmModules.default
      #   ];
      #   secrets = {
      #     "pbp-wireguard-private-key" = {};
      #     "cachix-personal-token".owner = "ccr";
      #     "chatgpt-token".owner = "ccr";
      #   };
      # };
      kirk = {
        vpn = {
          ip = "10.100.0.3";
          publicKey = "GrCpICbC25FQ+7JXgOJ9btvZp8YI/uecyBXx9IevsBo=";
        };
        extraModules = [
          inputs.disko.nixosModules.disko
          inputs.nixosHardware.nixosModules.lenovo-thinkpad-x1-7th-gen
        ];
        extraHmModules = [
          inputs.ccrEmacs.hmModules.default
          "${inputs.homeManagerGitWorkspace}/modules/services/git-workspace.nix"
          "${inputs.homeManagerSwayNC}/modules/services/swaync.nix"
        ];
        secrets = {
          "kirk-wireguard-private-key" = {};
          "chatgpt-token".owner = "ccr";
          "cachix-personal-token".owner = "ccr";
          "git-workspace-tokens".owner = "ccr";
          "autistici-password".owner = "ccr";
          "restic-hetzner-password" = {};
        };
      };

      picard = {
        vpn = {
          ip = "10.100.0.2";
          publicKey = "O9V2PI7+vZm7gGn3f9SaTsJbVe9urf/jZkdXFz/mjVU=";
        };
        extraModules = [
          inputs.disko.nixosModules.disko
        ];
        extraHmModules = [
          inputs.ccrEmacs.hmModules.default
          "${inputs.homeManagerGitWorkspace}/modules/services/git-workspace.nix"
          "${inputs.homeManagerSwayNC}/modules/services/swaync.nix"
        ];
        secrets = {
          "picard-wireguard-private-key" = {};
          "chatgpt-token".owner = "ccr";
          "cachix-personal-token".owner = "ccr";
          "hercules-ci-join-token".owner = "hercules-ci-agent";
          "hercules-ci-binary-caches".owner = "hercules-ci-agent";
          "hercules-ci-secrets-json".owner = "hercules-ci-agent";
          "git-workspace-tokens".owner = "ccr";
          "autistici-password".owner = "ccr";
          "restic-hetzner-password" = {};
        };
      };

      sisko = {
        system = "aarch64-linux";
        vpn = {
          ip = "10.100.0.1";
          publicKey = "bc5giljukT1+ChbbyTLdOfejfR3c8RZ4XoXmQM54nTY=";
        };
        extraModules = with inputs; [
          disko.nixosModules.disko
          rock5b.nixosModules.default
        ];
        secrets = {
          "sisko-wireguard-private-key" = {};
          "hercules-ci-join-token".owner = "hercules-ci-agent";
          "hercules-ci-binary-caches".owner = "hercules-ci-agent";
          "hercules-ci-secrets-json".owner = "hercules-ci-agent";
          "cachix-personal-token".owner = "ccr";
          "home-planimetry".owner = "hass";
          "cloudflare-dyndns-api-token" = {};
          "restic-hetzner-password" = {};
        };
      };
    };

    vpnExtra = {
      oneplus6t = {
        ip = "10.100.0.4";
        publicKey = "O6/tKaA8Hs7OEqi15hV4RwviR6vyCTMYv6ZlhsI+tnI=";
      };
    };
  };

  flake.nixosConfigurations =
    lib.mapAttrs
    config.fleet._mkNixosConfiguration
    config.fleet.hosts;
}
