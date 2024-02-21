{config, ...}: {
  services.hercules-ci-agent = {
    enable = true;
    settings = {
      concurrentTasks = "auto";
      clusterJoinTokenPath = config.age.secrets.hercules-ci-join-token.path;
      # binaryCachesPath = config.age.secrets.hercules-ci-binary-caches.path;
      secretsJsonPath = config.age.secrets.hercules-ci-secrets-json.path;
    };
  };

  systemd.tmpfiles.rules = [
    "d ${config.users.users.root.home}/.aws 770 root root"
    "d ${config.users.users.hercules-ci-agent.home}/.aws 770 hercules-ci-agent hercules-ci-agent"
  ];

  system.activationScripts.aws-credentials = ''
    install ${config.age.secrets.aws-credentials.path} \
      ${config.users.users.hercules-ci-agent.home}/.aws/credentials \
      -D \
      --owner=hercules-ci-agent \
      --group=hercules-ci-agent \
      --mode=770

    install \
      ${config.age.secrets.aws-credentials.path} \
      -D \
      ${config.users.users.root.home}/.aws/credentials
  '';
}
