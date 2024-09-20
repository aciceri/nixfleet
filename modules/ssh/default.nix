{ fleetFlake, ... }:
{
  services = {
    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "prohibit-password";
      };
    };

    fail2ban = {
      enable = true;
      maxretry = 10;
    };
  };

  # This makes sense only because I'm the only user for these machines
  users.users.root.openssh.authorizedKeys.keys = builtins.attrValues (
    with (import "${fleetFlake}/lib"); keys.users // keys.hosts
  );
}
