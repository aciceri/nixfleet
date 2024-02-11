{
  config,
  lib,
  ...
}: {
  users.users.forgejo-runners = {
    isSystemUser = true;
    group = "forgejo-runners";
  };

  users.groups.forgejo-runners = {};

  services.gitea-actions-runner.instances.test = {
    enable = true;
    name = "test";
    url = "https://git.aciceri.dev";
    tokenFile = config.age.secrets.forgejo-runners-token.file;
    labels = ["test"];
  };

  systemd.services.gitea-runner-test.serviceConfig = {
    User = lib.mkForce "forgejo-runners";
    Group = lib.mkForce "forgejo-runners";
  };
}
