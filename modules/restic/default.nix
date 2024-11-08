# To restore something use something like
# restic-sisko restore <snapshot_id> --include /persist/var/lib/hass --target /
# To get snaphots run restic-sisko snapshots
{
  config,
  pkgs,
  lib,
  ...
}:
let
  user = "u382036-sub1";
  host = "u382036.your-storagebox.de";
  port = "23";
in
{
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

  services.openssh.knownHosts."${
    host
  }".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIICf9svRenC/PLKIL9nk6K/pxQgoiFC41wTNvoIncOxs";

  services.postgresqlBackup = {
    enable = true;
    backupAll = true;
    location = "/var/backup/postgresql";
  };

  environment.persistence."/persist".directories = [
    config.services.postgresqlBackup.location
  ];

  services.restic.backups.sisko = {
    paths = [
      "/persist"
      "/mnt/hd/immich"
      "/mnt/hd/paperless"
    ];
    exclude = [ " /persist/var/lib/containers" ];
    passwordFile = config.age.secrets.SISKO_RESTIC_PASSWORD.path;
    extraOptions = [
      "sftp.command='${lib.getExe pkgs.sshpass} -f ${config.age.secrets.HETZNER_STORAGE_BOX_SISKO_SSH_PASSWORD.path} ssh -p${port} ${user}@${host} -s sftp'"
    ];
    repository = "sftp://${user}@${host}:${port}/";
    initialize = true;
    pruneOpts = [
      "--keep-yearly 1"
      "--keep-monthly 2"
      "--keep-daily 7"
    ];
    timerConfig.OnCalendar = "daily";
    timerConfig.RandomizedDelaySec = "1h";
    backupPrepareCommand = ''
      ${pkgs.systemd}/bin/systemctl stop podman-*
      ${pkgs.systemd}/bin/systemctl stop syncthing
      ${pkgs.systemd}/bin/systemctl stop paperless-*
      ${pkgs.systemd}/bin/systemctl stop forgejo
      ${pkgs.systemd}/bin/systemctl stop home-assistant
    '';
    backupCleanupCommand = ''
      ${pkgs.systemd}/bin/systemctl start --no-block --all "podman-*"
      ${pkgs.systemd}/bin/systemctl start syncthing
      ${pkgs.systemd}/bin/systemctl start --no-block --all "paperless-*"
      ${pkgs.systemd}/bin/systemctl start forgejo
      ${pkgs.systemd}/bin/systemctl start home-assistant
    '';
  };
}
