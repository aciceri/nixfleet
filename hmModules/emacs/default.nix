{
  lib,
  age,
  ...
}:
{
  ccrEmacs.enable = true;
  home.sessionVariables.EDITOR = lib.mkForce "emacsclient";
  systemd.user.services.emacs.Service.EnvironmentFile = age.secrets.chatgpt-token.path;
}
