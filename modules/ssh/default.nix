{fleetFlake, ...}: {
  services = {
    sshd.enable = true;
    fail2ban = {
      enable = true;
      maxretry = 10;
    };
  };
  users.users.root.openssh.authorizedKeys.keys = builtins.attrValues (import "${fleetFlake}/lib").keys.users;
}
