{
  pkgs,
  lib,
  fleetFlake,
  ...
}: {
  security.polkit.enable = true;
  virtualisation.libvirtd.enable = true;

  networking.firewall.interfaces."wg0".allowedTCPPorts = [
    5900 # vnc by QEMU
    3389 # rdp installed in Windows itself
  ];

  boot.kernelParams = [
    "intel_iommu=on"
    "iommu=pt"
  ];

  systemd.services.vm-mara = let
    start-vm = pkgs.writeShellApplication {
      name = "start-vm";
      runtimeInputs = with pkgs; [qemu];
      text = ''
        [ ! -f /var/lib/vm-mara/w10.qcow2 ] && \
          qemu-img create -f qcow2 /var/lib/vm-mara/w10.qcow2 50G

        qemu-system-x86_64 \
          -enable-kvm \
          -cpu host \
          -smp 2 \
          -m 4096 \
          -nic user,model=virtio-net-pci,hostfwd=tcp::3389-:3389 \
          -vnc :0 \
          -cdrom /var/lib/vm-mara/virtio-win.iso \
          -device nec-usb-xhci,id=usb,bus=pci.0,addr=0x4 \
          -device usb-tablet \
          -audiodev alsa,id=snd0,out.try-poll=off -device ich9-intel-hda -device hda-output,audiodev=snd0 \
          -drive file=/var/lib/vm-mara/w10.qcow2
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
