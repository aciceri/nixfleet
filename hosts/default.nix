{
  self,
  lib,
  config,
  inputs,
  ...
}: {
  imports = [./module.nix];

  fleet.hosts = {
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

    picard = {
      extraModules = [
        inputs.disko.nixosModules.disko
      ];
      extraHmModules = [
        inputs.ccrEmacs.hmModules.default
        "${inputs.homeManagerGitWorkspace}/modules/services/git-workspace.nix"
      ];
      secrets = {
        "chatgpt-token".owner = "ccr";
        "cachix-personal-token".owner = "ccr";
        "hercules-ci-join-token".owner = "hercules-ci-agent";
        "hercules-ci-binary-caches".owner = "hercules-ci-agent";
        "hercules-ci-secrets-json".owner = "hercules-ci-agent";
        "git-workspace-tokens".owner = "ccr";
      };
    };

    sisko = {
      system = "aarch64-linux";
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
      };
    };
  };

  flake.nixosConfigurations =
    lib.mapAttrs
    config.fleet._mkNixosConfiguration
    config.fleet.hosts;
}
