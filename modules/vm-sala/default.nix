{
  pkgs,
  lib,
  fleetFlake,
  ...
}: {
  security.polkit.enable = true;
  virtualisation.libvirtd.enable = true;

  networking.firewall.allowedTCPPorts = [
    2222
  ];

  imports = [../nginx-base];

  services.nginx.virtualHosts."git.slavni.aciceri.dev" = {
    forceSSL = true;
    enableACME = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:13000";
    };
  };

  systemd.services.vm-sala = let
    initial-config = fleetFlake.inputs.nixos-generators.nixosGenerate {
      system = "x86_64-linux";
      modules = [
        fleetFlake.inputs.nixos-vscode-server.nixosModule
        ({
          modulesPath,
          lib,
          config,
          ...
        }: {
          services.vscode-server = {
            enable = true;
            enableFHS = true;
          };
          system.build.qcow = lib.mkForce (import "${toString modulesPath}/../lib/make-disk-image.nix" {
            inherit lib config pkgs;
            diskSize = 50 * 1024;
            format = "qcow2";
            partitionTableType = "hybrid";
          });
          services.openssh.enable = true;
          environment.systemPackages = with pkgs; [
            vim
            git
            htop
          ];
          users.users.root = {
            password = "password";
            openssh.authorizedKeys.keys = [
              (import "${fleetFlake.outPath}/lib").keys.users.ccr-ssh
              "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC7qikwR0a4LDoMQIVvtX+gyJ41OsAOWe8RcXc4ksIBP9x1nCcSrItlgC2soADB77QGIgyeyLGmnTCtMj5/s8NdREAycPeXLii1WRakbT7oZ/hTEmvAgObpadeYJn3LhaUDNtmsnAqqh2pRpCpSsAdhfIt+YyV4VgRYSfaa12Ozp/H6NI9bJMNttmG8TmY9V4zyskV9bE+up9y8Yuck2bZV/GjQe6UWgxsiC3XPSrFFGuxyaFMRGsc8h86xVwTAmwaHESEFhRvHD4EtdPNss0jqmSI6m4AoSZQ2wq7eiH8ZiYzERF0FnEFf4UsyOTM7j78bfogNLfKrdcEIPLrNNFFc3Iarfe9CJn3DdSnwwPnhFU1MBBXSbGOp1IyN3+gpjHwLMPzozlDAVqOwx6XpnpF78VpeknFBHCbkcKC/R0MXzqf900wH3i2HvfB7v9e9EUFzCQ0vUC+1Og+BFw3F5VSo0QtZyLc4BJ/akBs5mEE6TnuWQa/GhlY8Lz7wbcV1AaBOAQdx+NTbL/+Q31SJ1XsXtGtXCrwMY9noUTyVfpGVXo7Mn4HSslmeQ9SKfYKjyetkBR/1f8a47O3rCggjBy1AlfLjgbERnXy+0Ma4T8lnPZAKt3s9Ya1JupZ7SO7D5j7WfPKP+60c372/RrX1wXsxEeLvBJ0jd8GnSCXDOuvHTQ=="
            ];
          };
        })
      ];
      format = "qcow";
    };
    image = "${initial-config}/nixos.qcow2";
    start-vm = pkgs.writeShellApplication {
      name = "start-vm";
      runtimeInputs = with pkgs; [qemu];
      text = ''
        [ ! -f /var/lib/vm-sala/nixos.qcow2 ] && \
          install ${image} /var/lib/vm-sala

        qemu-system-x86_64 \
          -enable-kvm \
          -cpu host \
          -smp 2 \
          -m 4096 \
          -nic user,model=virtio-net-pci,hostfwd=tcp::2222-:22,hostfwd=tcp::13000-:3000 \
          -nographic \
          -drive file=/var/lib/vm-sala/nixos.qcow2
      '';
    };
  in {
    wantedBy = ["multi-user.target"];
    after = ["network.target"];
    serviceConfig = {
      ExecStart = "${start-vm}/bin/start-vm";
    };
  };
}
