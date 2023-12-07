{config, ...}: {
  # For unlocking the disk connect using ssh and type
  # systemctl start initrd-nixos-activation
  boot.initrd = {
    network = {
      enable = true;
      ssh = {
        enable = true;
        ignoreEmptyHostKeys = true;
        extraConfig = ''
          HostKey /ssh_initrd_host_ed25519_key
        '';
      };
    };
    systemd = {
      enable = true;
      storePaths = ["${config.programs.ssh.package}/bin/ssh-keygen"];
      services.sshd.preStart = ''
               ${config.programs.ssh.package}/bin/ssh-keygen -t ed25519 -N "" -f /ssh_initrd_host_ed25519_key
        chmod 600 /ssh_initrd_host_ed25519_key
      '';
    };
  };
}
