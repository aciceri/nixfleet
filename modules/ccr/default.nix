{
  config,
  lib,
  pkgs,
  fleetHmModules,
  ...
}: {
  users.users.ccr = {
    uid = 1000;
    hashedPassword = "$6$JGOefuRk7kL$fK9.5DFnLLoW08GL4eKRyf958jyZdw//hLMaz4pp28jJuSFb24H6R3dgt1.sMs0huPY85rludSw4dnQJG5xSw1"; # mkpasswd -m sha-512
    description = "Andrea Ciceri";
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "fuse"
      "video"
      "adbusers"
      "docker"
      "networkmanager"
      "dialout"
      "bluetooth"
      "camera"
    ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDJmn7H6wxrxCHypvY74Z6pBr5G6v564NaUZb9xIILV92JEdpZzuTLLlP+JkMx/8MLRy+pC7prMwR+FhH+LaTm/9x3T6FYP/q9UIAL3cFwBAwj5XQXQKzx9f6pX/7iJrMfAUQ+ZrRUNJHt5Gl+8UypmDgnQLuv5vmQSMRzKnUPuu4lCJtWOpSPhXffz3Ec1tm5nAMuxIMRPY91PYu1fMLlFrjB1FX1goVHKB1uWx16GjJszYCVbN6xcPac0sgUg+qNGBhWkUh0F073rhepQJeWp5FtwIxe2zRsZBxxTy5qxNLmHzBeNDxlOkcy2/Lr+BxVy+mhF/2fJziX80/bWSEA1"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDynKeHTnXOTCi+MH2agM4k5uBkTL+W5xkL/ep3DKuTIb9MbKjHkRIquSdVRAit4ZQVQN+S3yoCXCRdLLurM3/a6C7vc/a3UfGPyV/oDYDCdHNsOwimqIQg8Pc0WtnevLpZTC2VR4UU8zzaD/mmEWqxNszaNNUve+Fy0lwg6jn6vTnQCupbyMnghherozPJu94H/JLuDEcPT0wZUmBjhjT+yHp65Yk8hKVb1jRqEdjAHM4yZf6ceIxI9NMGeSnAKf/b8IsO6y7A93NZ75CnD6AW9Rclemi+nOqZo9zQ2m2LRtMTHSoNOLLkNQCCD+l2G4w1wPMONw4mz1vR917iJdd+5BXDtEVwScDfOmqVewynxkfztSvB+qTDzdqde3NO8fFA8jMk3rUXXfIl/Yb0G87wVT/Jcl7+ZBch8s+ljPsmyy5RY+uXLgKgE1tne0KJuzeJtxSAzTrPUhILB/A8PuJUzVGVWAdGRcusOc/0SdsluFsa11E0D946JcgNo72bWm0="
    ];
  };

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.ccr = {
    imports = fleetHmModules [
      "shell"
      "emacs"
      "mpv"
      "firefox"
      "qutebrowser"
      "git"
      "gpg"
      "password-store"
      "slack"
      "chrome"
      "vscode"
      "element"
      "udiskie"
      "discord"
    ];
    home.packages = with pkgs; [
    ];
    home.stateVersion = config.system.stateVersion;
  };
}
