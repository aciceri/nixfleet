{fleetFlake, ...}: {
  services.sshd.enable = true;
  users.users.root.openssh.authorizedKeys.keys = builtins.attrValues (import "${fleetFlake}/lib").keys.users;
}
