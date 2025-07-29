{
  config,
  pkgs,
  lib,
  fleetFlake,
  ...
}:
let
  sshdTmpDirectory = "${config.user.home}/sshd-tmp";
  sshdDirectory = "${config.user.home}/sshd";
  port = 8022;
in
{
  # Backup etc files instead of failing to activate generation if a file already exists in /etc
  environment.etcBackupExtension = ".bak";

  # Read the changelog before changing this value
  system.stateVersion = "24.05";

  # Set up nix for flakes
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  # Set your time zone
  time.timeZone = "Europe/Rome";

  home-manager.config =
    { ... }:
    {
      home.stateVersion = "24.05";
      _module.args = {
        hostname = "janeway";
        age.secrets = { };
      };
      home.enableNixpkgsReleaseCheck = false;
      _module.args = {
        username = "ccr";
      };
      programs.git.extraConfig.user.signingKey =
        lib.mkForce "/data/data/com.termux.nix/files/home/.ssh/id_ed25519";
      imports = [
        ../../hmModules/shell
        ../../hmModules/git
      ];
    };

  build.activation.sshd =
    let
      keys = (builtins.import ../../lib).keys;
      inherit (keys) hosts users;
    in
    ''
      $DRY_RUN_CMD mkdir $VERBOSE_ARG --parents "${config.user.home}/.ssh"
      $DRY_RUN_CMD echo ${hosts.picard} > "${config.user.home}/.ssh/authorized_keys"
      $DRY_RUN_CMD echo ${hosts.sisko} >> "${config.user.home}/.ssh/authorized_keys"
      $DRY_RUN_CMD echo ${hosts.kirk} >> "${config.user.home}/.ssh/authorized_keys"
      $DRY_RUN_CMD echo ${hosts.pike} >> "${config.user.home}/.ssh/authorized_keys"
      $DRY_RUN_CMD echo ${users.ccr-ssh} >> "${config.user.home}/.ssh/authorized_keys"

      if [[ ! -d "${sshdDirectory}" ]]; then
        $DRY_RUN_CMD rm $VERBOSE_ARG --recursive --force "${sshdTmpDirectory}"
        $DRY_RUN_CMD mkdir $VERBOSE_ARG --parents "${sshdTmpDirectory}"

        $VERBOSE_ECHO "Generating host keys..."
        $DRY_RUN_CMD ${pkgs.openssh}/bin/ssh-keygen -t rsa -b 4096 -f "${sshdTmpDirectory}/ssh_host_rsa_key" -N ""

        $VERBOSE_ECHO "Writing sshd_config..."
        $DRY_RUN_CMD echo -e "HostKey ${sshdDirectory}/ssh_host_rsa_key\nPort ${toString port}\n" > "${sshdTmpDirectory}/sshd_config"

        $DRY_RUN_CMD mv $VERBOSE_ARG "${sshdTmpDirectory}" "${sshdDirectory}"
      fi
    '';

  environment.packages = with pkgs; [
    bottom
    helix
    stress
    openssh
    btop
    busybox
    gnupg
    zellij
    (claude-code.overrideAttrs (old: {
      meta = old.meta // {
        license = lib.licenses.gpl3; # it's unfree but for some reason setting allowUnfreePredicate doesn't work
      };
    }))
    (pkgs.writeScriptBin "sshd-start" ''
      #!${pkgs.runtimeShell}
      echo "Starting sshd in non-daemonized way on port ${toString port}"
      ${pkgs.openssh}/bin/sshd -f "${sshdDirectory}/sshd_config" -D
    '')
  ];
}
