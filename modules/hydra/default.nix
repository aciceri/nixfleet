{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.services.my-hydra;
  toSpec =
    {
      name,
      owner,
      ...
    }:
    let
      spec = {
        enabled = 1;
        hidden = false;
        description = "Declarative specification jobset automatically generated";
        checkinterval = 120;
        schedulingshares = 10000;
        enableemail = false;
        emailoverride = "";
        keepnr = 1;
        nixexprinput = "src";
        nixexprpath = "jobsets.nix";
        inputs = {
          src = {
            type = "path";
            value = pkgs.writeTextFile {
              name = "src";
              text = builtins.readFile ./jobsets.nix;
              destination = "/jobsets.nix";
            };
            emailresponsible = false;
          };
          repoInfoPath = {
            type = "path";
            value = pkgs.writeTextFile {
              name = "repo";
              text = builtins.toJSON {
                inherit name owner;
              };
            };
            emailresponsible = false;
          };
          prs = {
            type = "githubpulls";
            value = "${owner} ${name}";
            emailresponsible = false;
          };
        };
      };
      drv = pkgs.writeTextFile {
        name = "hydra-jobset-specification-${name}";
        text = builtins.toJSON spec;
        destination = "/spec.json";
      };
    in
    "${drv}";
in
{
  imports = [
    ./config.nix
    ../nginx-base
  ];

  options.services.my-hydra = {
    domain = lib.mkOption {
      type = lib.types.str;
      default = "hydra.aciceri.dev";
    };
    repos = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule (
          {
            name,
            config,
            ...
          }:
          {
            options = {
              name = lib.mkOption {
                type = lib.types.str;
                default = name;
              };
              owner = lib.mkOption {
                type = lib.types.str;
                default = "aciceri";
              };
              description = lib.mkOption {
                type = lib.types.str;
                default = config.homepage;
              };
              homepage = lib.mkOption {
                type = lib.types.str;
                default = "https://github.com/${config.owner}/${config.name}";
              };
              reportStatus = lib.mkOption {
                type = lib.types.bool;
                default = true;
              };
            };
          }
        )
      );
      default = { };
    };
  };

  config = {
    # TODO manage `hydra` user ssh key declaratively
    nix.extraOptions = ''
      allowed-uris = https://github.com/ git://git.savannah.gnu.org/ https://git.sr.ht
    '';

    services.hydra-dev = {
      enable = true;
      hydraURL = "https://${cfg.domain}";
      notificationSender = "hydra@mothership.fleet";
      useSubstitutes = true;
      extraConfig =
        ''
          <github_authorization>
          include ${config.age.secrets.hydra-github-token.path}
          </github_authorization>
        ''
        + (lib.concatMapStrings (
          repo:
          lib.optionalString repo.reportStatus ''
            <githubstatus>
              jobs = ${repo.name}.*
              excludeBuildFromContext = 1
              useShortContext = 1
            </githubstatus>
          ''
        ) (builtins.attrValues cfg.repos));
    };

    systemd.services.hydra-setup = {
      description = "Hydra CI setup";
      serviceConfig.Type = "oneshot";
      serviceConfig.RemainAfterExit = true;
      wantedBy = [ "multi-user.target" ];
      requires = [ "hydra-init.service" ];
      after = [ "hydra-init.service" ];
      environment = builtins.removeAttrs (config.systemd.services.hydra-init.environment) [ "PATH" ];
      script =
        ''
          PATH=$PATH:${
            lib.makeBinPath (
              with pkgs;
              [
                yq-go
                curl
                config.services.hydra.package
              ]
            )
          }
          PASSWORD="$(cat ${config.age.secrets.hydra-admin-password.path})"
          if [ ! -e ~hydra/.setup-is-complete ]; then
            hydra-create-user admin \
              --full-name "Andrea Ciceri" \
              --email-address "andrea.ciceri@autistici.org" \
              --password "$PASSWORD" \
              --role admin
            touch ~hydra/.setup-is-complete
          fi

          mkdir -p /var/lib/hydra/.ssh
          cp /home/ccr/.ssh/id_rsa* /var/lib/hydra/.ssh/
          chown -R hydra:hydra /var/lib/hydra/.ssh

          mkdir -p /var/lib/hydra/queue-runner/.ssh
          cp /home/ccr/.ssh/id_rsa* /var/lib/hydra/queue-runner/.ssh/
          chown -R hydra-queue-runner:hydra /var/lib/hydra/queue-runner/.ssh

          curl --head -X GET --retry 5 --retry-connrefused --retry-delay 1 http://localhost:3000

          CURRENT_REPOS=$(curl -s -H "Accept: application/json" http://localhost:3000 | yq ".[].name")
          DECLARED_REPOS="${lib.concatStringsSep " " (builtins.attrNames cfg.repos)}"

          curl -H "Accept: application/json" \
            -H 'Origin: http://localhost:3000' \
            -H 'Content-Type: application/json' \
            -d "{\"username\": \"admin\", \"password\": \"$PASSWORD\"}" \
            --request "POST" localhost:3000/login \
            --cookie-jar cookie

          for repo in $CURRENT_REPOS; do
            echo $repo
            [[ ! "$DECLARED_REPOS" =~ (\ |^)$repo(\ |$) ]] && \
              curl -H "Accept: application/json" \
                --request "DELETE" \
                --cookie cookie \
                http://localhost:3000/project/$repo
          done
        ''
        + lib.concatMapStrings (repo: ''
          curl -H "Accept: application/json" \
            -H 'Content-Type: application/json' \
            --request "PUT" \
            localhost:3000/project/${repo.name} \
            --cookie cookie \
            -d '{
              "name": "${repo.name}",
              "displayname": "${repo.name}",
              "description": "${repo.description}",
              "homepage": "${repo.homepage}",
              "owner": "admin",
              "enabled": true,
              "visible": true,
              "declarative": {
                "file": "spec.json",
                "type": "path",
                "value": "${toSpec repo}"
              }
            }'
        '') (builtins.attrValues cfg.repos)
        + ''
          rm cookie
        '';
    };

    services.nginx.virtualHosts."${cfg.domain}" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${builtins.toString config.services.hydra.port}";
      };
    };
  };
}
