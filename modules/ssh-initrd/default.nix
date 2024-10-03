{
  config,
  pkgs,
  ...
}:
{
  # For unlocking the disk connect using ssh and type
  # systemctl start initrd-nixos-activation
  boot.initrd = {
    network = {
      ssh = {
        enable = true;
        ignoreEmptyHostKeys = true;
        extraConfig = ''
          HostKey /ssh_initrd_host_ed25519_key
        '';
        authorizedKeys = with (import ../../lib).keys; [
          users.ccr-gpg
          users.ccr-ssh
          hosts.sisko
        ];
      };
    };
    systemd = {
      enable = true;
      network.enable = true;
      storePaths = [
        "${config.programs.ssh.package}/bin/ssh-keygen"
        "${pkgs.bashInteractive}/bin/bash"
      ];
      services.sshd.preStart = ''
        [ ! -f /ssh_initrd_host_ed25519_key ] && ${config.programs.ssh.package}/bin/ssh-keygen -t ed25519 -N "" -f /ssh_initrd_host_ed25519_key
        chmod 600 /ssh_initrd_host_ed25519_key
      '';
    };
  };

  # boot.initrd.systemd.additionalUpstreamUnits = ["debug-shell.service"];
  # boot.kernelParams = ["rd.systemd.debug_shell"];
}
