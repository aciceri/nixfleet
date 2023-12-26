{
  config,
  pkgs,
  lib,
  ...
}: {
  options.backup = {
    paths = lib.mkOption {
      type = lib.types.listOf lib.types.path;
      default = [];
    };
  };
  config.services.restic = {
    backups = {
      hetzner = {
        paths = config.backup.paths;
        passwordFile = config.age.secrets.restic-hetzner-password.path;
        extraOptions = [
          # Use the host ssh key, for authorizing new hosts:
          # cat /etc/ssh/ssh_host_ed25519_key.pub | ssh -p23 u382036-sub1@u382036-sub1.your-storagebox.de install-ssh-key
          "sftp.command='ssh -p23 u382036-sub1@u382036-sub1.your-storagebox.de -i /etc/ssh/ssh_host_ed25519_key -s sftp'"
        ];
        repository = "sftp://u382036-sub1@u382036-sub1.your-storagebox.de:23/";
        initialize = true;
        timerConfig.OnCalendar = "daily";
        timerConfig.RandomizedDelaySec = "1h";
      };
    };
  };

  config.environment.systemPackages = builtins.map (path:
    pkgs.writeShellApplication {
      name = "restic-restore-${builtins.replaceStrings ["/"] ["-"] path}";
      runtimeInputs = with pkgs; [restic];
      text = ''
        restic -r ${config.services.restic.backups.hetzner.repository} \
          ${lib.concatMapStringsSep ''\'' (option: "-o ${option}") config.services.restic.backups.hetzner.extraOptions} \
          --password-file ${config.services.restic.backups.hetzner.passwordFile} \
          restore latest \
          --path "${path}"\
          --target "$1"
      '';
    })
  config.services.restic.backups.hetzner.paths;
}
