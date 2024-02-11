{pkgs, ...}: {
  # Creates an user that home assistant can log in as to power off the system
  users.users.hass = {
    openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFcoVVrMFili8UBjziIu2wyFgcDGTlT1avBh2nLTa9aM"];
    isNormalUser = true;
    isSystemUser = false;
    group = "hass";
    createHome = false;
  };

  users.groups.hass = {};

  security.sudo.extraConfig = ''
    hass ALL=NOPASSWD:${pkgs.systemd}/bin/systemctl
  '';
}
