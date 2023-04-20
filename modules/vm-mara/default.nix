{
  pkgs,
  lib,
  fleetFlake,
  ...
}: {
  security.polkit.enable = true;
  virtualisation.libvirtd.enable = true;

  networking.firewall.interfaces."wg0" = {
    allowedTCPPorts = [
      5900 # vnc by QEMU
      3389 # rdp installed in Windows itself
      47984
      47989
      48010 # sunshine/moonlight
      47990 # sunshine webui
    ];
    allowedUDPPortRanges = [
      {
        from = 47998;
        to = 48000;
      }
      {
        from = 48002;
        to = 48010;
      }
    ];
  };

  boot.kernelParams = [
    "intel_iommu=on"
    "iommu=pt"
  ];

  boot.initrd.availableKernelModules = ["vfio-pci"];
  boot.initrd.preDeviceCommands = ''
    echo "vfio-pci" > /sys/bus/pci/devices/0000:00:02.0/driver_override
    modprobe -i vfio-pci
  '';

  # -vnc :0 \
  # -audiodev alsa,id=snd0,out.try-poll=off -device ich9-intel-hda -device hda-output,audiodev=snd0 \

  systemd.services.vm-mara = let
    start-vm = pkgs.writeShellApplication {
      name = "start-vm";
      runtimeInputs = with pkgs; [qemu];
      text = ''
        [ ! -f /var/lib/vm-mara/w10.qcow2 ] && \
          qemu-img create -f qcow2 /var/lib/vm-mara/w10.qcow2 50G

        qemu-system-x86_64 \
          -enable-kvm \
          -cpu host,kvm=off \
          -smp 2 \
          -m 4096 \
          -nic user,model=virtio-net-pci,hostfwd=tcp::3389-:3389,hostfwd=tcp::47989-:47989,hostfwd=tcp::47990-:47990,hostfwd=tcp::47984-:47984,hostfwd=tcp::48010-:48010,hostfwd=udp::47998-:47988,hostfwd=udp::47999-:47999,hostfwd=udp::48000-:48000,hostfwd=udp::48002-:48002,hostfwd=udp::48003-:48003,hostfwd=udp::48004-:48004,hostfwd=udp::48005-:48005,hostfwd=udp::48006-:48006,hostfwd=udp::48007-:48007,hostfwd=udp::48008-:48008,hostfwd=udp::48009-:48009,hostfwd=udp::48010-:48010 \
          -cdrom /var/lib/vm-mara/virtio-win.iso \
          -device nec-usb-xhci,id=usb,bus=pci.0,addr=0x4 \
          -device usb-tablet \
          -device vfio-pci,host=00:02.0 \
          -nographic \
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
