{
  lib,
  age,
  pkgs,
  ...
}: {
  ccrEmacs.enable = true;
  home.sessionVariables.EDITOR = lib.mkForce "emacsclient";
  systemd.user.services.emacs.Service.EnvironmentFile = age.secrets.chatgpt-token.path;
  home.packages = lib.lists.optional pkgs.stdenv.isx86_64 pkgs.llm-workflow-engine;
}
