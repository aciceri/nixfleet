{ pkgs, ... }:
{
  virtualisation.libvirtd.enable = true;

  networking.firewall.interfaces."wg0" = {
    allowedTCPPorts = [
      5900 # vnc by QEMU
      2233
      60022
      8545
    ];
  };

  systemd.services.vm-ubuntu =
    let
      start-vm = pkgs.writeShellApplication {
        name = "start-vm";
        runtimeInputs = with pkgs; [ qemu ];
        text = ''
          qemu-system-x86_64 \
            -enable-kvm \
            -cpu host,kvm=on,hv-vendor_id="GenuineIntel" \
            -smp 4 \
            -m 8192 \
            -nic user,model=virtio-net-pci,hostfwd=tcp::60022-:22,hostfwd=tcp::8545-:8545 \
            -drive file=/var/lib/vm-ubuntu/ubuntu.qcow2
        '';
      };
    in
    {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        ExecStart = "${start-vm}/bin/start-vm";
      };
    };
}
