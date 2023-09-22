{lib, ...}: {
  ccrEmacs.enable = true;
  home.sessionVariables.EDITOR = lib.mkForce "emacsclient";
}
