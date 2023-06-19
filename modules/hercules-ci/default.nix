{
  config,
  pkgs,
  ...
}: {
  services.hercules-ci-agent = {
    enable = true;
    settings = {
      concurrentTasks = 8;
      clusterJoinTokenPath = config.age.secrets.hercules-ci-join-token.path;
      binaryCachesPath = config.age.secrets.hercules-ci-binary-caches.path;
      # secretsJsonPath = config.hercules-ci-secrets.path;
    };
  };
}
