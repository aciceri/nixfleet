{fleetFlake, ...}: {
  services = {
    sshd.enable = true;

    fail2ban = {
      enable = true;
      maxretry = 10;
    };
  };

  # This makes sense only because I'm the only user for these machines
  users.users.root.openssh.authorizedKeys.keys = builtins.attrValues (with (import "${fleetFlake}/lib"); keys.users // keys.hosts);
}
