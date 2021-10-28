{ pkgs, suites, lib, ... }:
{
  home-manager.users.ccr = { suites, ... }: {
    imports = with suites; shell ++ gui ++ browser ++ multimedia ++ emails ++ dev ++ base;
    home.packages = with pkgs; [
      ack
      ranger
      imv
      calibre
      element-desktop
      gtk-engine-murrine
      gtk_engines
      gsettings-desktop-schemas
      lxappearance
      yarn
      yarn2nix
      texlive.combined.scheme-full
    ];
  };

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
    openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDJmn7H6wxrxCHypvY74Z6pBr5G6v564NaUZb9xIILV92JEdpZzuTLLlP+JkMx/8MLRy+pC7prMwR+FhH+LaTm/9x3T6FYP/q9UIAL3cFwBAwj5XQXQKzx9f6pX/7iJrMfAUQ+ZrRUNJHt5Gl+8UypmDgnQLuv5vmQSMRzKnUPuu4lCJtWOpSPhXffz3Ec1tm5nAMuxIMRPY91PYu1fMLlFrjB1FX1goVHKB1uWx16GjJszYCVbN6xcPac0sgUg+qNGBhWkUh0F073rhepQJeWp5FtwIxe2zRsZBxxTy5qxNLmHzBeNDxlOkcy2/Lr+BxVy+mhF/2fJziX80/bWSEA1" ];
  };
}
