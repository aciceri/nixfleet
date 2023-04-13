{fleetFlake, ...}: {
  services = {
    sshd.enable = true;

    fail2ban = {
      enable = true;
      maxretry = 10;
      ignoreIP = [
        "88.198.49.106"
        "10.100.0.1/24"
      ];
    };
  };
  users.users.root.openssh.authorizedKeys.keys = builtins.attrValues (with (import "${fleetFlake}/lib"); keys.users // keys.hosts);
}
