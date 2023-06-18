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
      # Don't need using private caches, if I would ever need remember to use agenix!
      binaryCachesPath = pkgs.writeText "binary-caches-path" (builtins.toJSON {});
      # secretsJsonPath = config.hci-secrets.hci-mlabs-haskell.target;
    };
  };
}
