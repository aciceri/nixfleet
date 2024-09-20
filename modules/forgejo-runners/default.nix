# heavily based on https://discourse.nixos.org/t/gitea-nix-actions-runner-setup/35279
{
  config,
  pkgs,
  lib,
  ...
}:
let
  storeDeps = pkgs.runCommand "store-deps" { } ''
    mkdir -p $out/bin
    for dir in ${
      with pkgs;
      builtins.toString [
        coreutils
        findutils
        gnugrep
        gawk
        git
        nix
        bash
        jq
        nodejs
        nix-fast-build
        curl
        tea
      ]
    }; do
      for bin in "$dir"/bin/*; do
        ln -s "$bin" "$out/bin/$(basename "$bin")"
      done
    done

    # Add SSL CA certs
    mkdir -p $out/etc/ssl/certs
    cp -a "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt" $out/etc/ssl/certs/ca-bundle.crt
  '';
  numInstances = 1;
  pushToCache = pkgs.writeScript "push-to-cache.sh" ''
    #!/bin/sh
    set -eu
    set -f # disable globbing
    export IFS=' '

    echo "Uploading paths" $OUT_PATHS
    exec nix copy --to "s3://cache?profile=default&region=eu-south-1&scheme=https&endpoint=cache.aciceri.dev" $OUT_PATHS
  '';
in
lib.mkMerge [
  {
    # everything here has no dependencies on the store
    systemd.services.gitea-runner-nix-image = {
      wantedBy = [ "multi-user.target" ];
      after = [ "podman.service" ];
      requires = [ "podman.service" ];
      path = [
        config.virtualisation.podman.package
        pkgs.gnutar
        pkgs.shadow
        pkgs.getent
      ];
      # we also include etc here because the cleanup job also wants the nixuser to be present
      script = ''
        set -eux -o pipefail
        mkdir -p etc/nix

        # Create an unpriveleged user that we can use also without the run-as-user.sh script
        touch etc/passwd etc/group
        groupid=$(cut -d: -f3 < <(getent group nixuser))
        userid=$(cut -d: -f3 < <(getent passwd nixuser))
        groupadd --prefix $(pwd) --gid "$groupid" nixuser
        emptypassword='$6$1ero.LwbisiU.h3D$GGmnmECbPotJoPQ5eoSTD6tTjKnSWZcjHoVTkxFLZP17W9hRi/XkmCiAMOfWruUwy8gMjINrBMNODc7cYEo4K.'
        useradd --prefix $(pwd) -p "$emptypassword" -m -d /tmp -u "$userid" -g "$groupid" -G nixuser nixuser

        echo -n "access-tokens = " > etc/nix/access-tokens
        cat ${config.age.secrets.forgejo-nix-access-tokens.path} >> etc/nix/access-tokens

        cat <<NIX_CONFIG > etc/nix/nix.conf
        accept-flake-config = true
        experimental-features = nix-command flakes
        post-build-hook = ${pushToCache}
        include access-tokens
        NIX_CONFIG

        cat <<NSSWITCH > etc/nsswitch.conf
        passwd:    files mymachines systemd
        group:     files mymachines systemd
        shadow:    files

        hosts:     files mymachines dns myhostname
        networks:  files

        ethers:    files
        services:  files
        protocols: files
        rpc:       files
        NSSWITCH

        # list the content as it will be imported into the container
        tar -cv . | tar -tvf -
        tar -cv . | podman import - gitea-runner-nix
      '';
      serviceConfig = {
        RuntimeDirectory = "gitea-runner-nix-image";
        WorkingDirectory = "/run/gitea-runner-nix-image";
        Type = "oneshot";
        RemainAfterExit = true;
      };
    };

    users.users.nixuser = {
      group = "nixuser";
      description = "Used for running nix ci jobs";
      home = "/var/empty";
      isSystemUser = true;
      # extraGroups = [ "podman" ];
    };
    users.groups.nixuser = { };
  }
  {
    # Format of the token file:
    virtualisation = {
      podman.enable = true;
    };

    # virtualisation.containers.storage.settings = {
    #   storage.driver = "zfs";
    #   storage.graphroot = "/var/lib/containers/storage";
    #   storage.runroot = "/run/containers/storage";
    #   storage.options.zfs.fsname = "zroot/root/podman";
    # };

    # virtualisation.containers.containersConf.settings = {
    #   # podman seems to not work with systemd-resolved
    #   containers.dns_servers = [ "8.8.8.8" "8.8.4.4" ];
    # };
  }
  {
    systemd.services =
      lib.genAttrs (builtins.genList (n: "gitea-runner-nix${builtins.toString n}") numInstances)
        (_name: {
          # TODO: systemd confinment
          serviceConfig = {
            # Hardening (may overlap with DynamicUser=)
            # The following options are only for optimizing output of systemd-analyze
            AmbientCapabilities = "";
            CapabilityBoundingSet = "";
            # ProtectClock= adds DeviceAllow=char-rtc r
            DeviceAllow = "";
            NoNewPrivileges = true;
            PrivateDevices = true;
            PrivateMounts = true;
            PrivateTmp = true;
            PrivateUsers = true;
            ProtectClock = true;
            ProtectControlGroups = true;
            ProtectHome = true;
            ProtectHostname = true;
            ProtectKernelLogs = true;
            ProtectKernelModules = true;
            ProtectKernelTunables = true;
            ProtectSystem = "strict";
            RemoveIPC = true;
            RestrictNamespaces = true;
            RestrictRealtime = true;
            RestrictSUIDSGID = true;
            UMask = "0066";
            ProtectProc = "invisible";
            SystemCallFilter = [
              "~@clock"
              "~@cpu-emulation"
              "~@module"
              "~@mount"
              "~@obsolete"
              "~@raw-io"
              "~@reboot"
              "~@swap"
              # needed by go?
              #"~@resources"
              "~@privileged"
              "~capset"
              "~setdomainname"
              "~sethostname"
            ];
            RestrictAddressFamilies = [
              "AF_INET"
              "AF_INET6"
              "AF_UNIX"
              "AF_NETLINK"
            ];

            # Needs network access
            PrivateNetwork = false;
            # Cannot be true due to Node
            MemoryDenyWriteExecute = false;

            # The more restrictive "pid" option makes `nix` commands in CI emit
            # "GC Warning: Couldn't read /proc/stat"
            # You may want to set this to "pid" if not using `nix` commands
            ProcSubset = "all";
            # Coverage programs for compiled code such as `cargo-tarpaulin` disable
            # ASLR (address space layout randomization) which requires the
            # `personality` syscall
            # You may want to set this to `true` if not using coverage tooling on
            # compiled code
            LockPersonality = false;

            # Note that this has some interactions with the User setting; so you may
            # want to consult the systemd docs if using both.
            DynamicUser = true;
          };
        });

    services.gitea-actions-runner = {
      package = pkgs.forgejo-actions-runner;
      instances = lib.genAttrs (builtins.genList (n: "nix${builtins.toString n}") numInstances) (name: {
        enable = true;
        name = "nix-runner";
        # take the git root url from the gitea config
        # only possible if you've also configured your gitea though the same nix config
        # otherwise you need to set it manually
        url = "https://git.aciceri.dev";
        # use your favourite nix secret manager to get a path for this
        tokenFile = config.age.secrets.forgejo-runners-token.path;
        labels = [ "nix:docker://gitea-runner-nix" ];
        settings = {
          container.options = "-e NIX_BUILD_SHELL=/bin/bash -e PAGER=cat -e PATH=/bin -e SSL_CERT_FILE=/etc/ssl/certs/ca-bundle.crt --device /dev/kvm -v /nix:/nix -v ${storeDeps}/bin:/bin -v ${storeDeps}/etc/ssl:/etc/ssl --user nixuser --device=/dev/kvm";
          # the default network that also respects our dns server settings
          container.network = "host";
          container.valid_volumes = [
            "/nix"
            "${storeDeps}/bin"
            "${storeDeps}/etc/ssl"
          ];
        };
      });
    };
  }
]
