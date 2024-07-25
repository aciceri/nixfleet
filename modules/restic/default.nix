{
  config,
  pkgs,
  lib,
  ...
}: let
  user = "u382036-sub1";
  host = "u382036.your-storagebox.de";
  port = "23";
in {
  age.secrets = {
    HETZNER_STORAGE_BOX_SISKO_SSH_PASSWORD = {
      file = ../../secrets/hetzner-storage-box-sisko-ssh-password.age;
      owner = "root";
    };
    SISKO_RESTIC_PASSWORD = {
      file = ../../secrets/sisko-restic-password.age;
      owner = "root";
    };
  };

  services.openssh.knownHosts."${host}".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIICf9svRenC/PLKIL9nk6K/pxQgoiFC41wTNvoIncOxs";

  services.restic.backups.sisko = {
    paths = ["/persist"];
    passwordFile = config.age.secrets.SISKO_RESTIC_PASSWORD.path;
    extraOptions = [
      "sftp.command='${lib.getExe pkgs.sshpass} -f ${config.age.secrets.HETZNER_STORAGE_BOX_SISKO_SSH_PASSWORD.path} ssh -p${port} ${user}@${host} -s sftp'"
    ];
    repository = "sftp://${user}@${host}:${port}/";
    initialize = true;
    timerConfig.OnCalendar = "daily";
    timerConfig.RandomizedDelaySec = "1h";
  };
}
