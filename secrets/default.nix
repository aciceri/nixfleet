let
  keys = (import ../lib).keys;
in
  with keys.hosts;
  with keys.users; {
    "cachix-personal-token.age".publicKeys = [ccr-ssh ccr-gpg mothership thinkpad];
    "magit-forge-github-token.age".publicKeys = [ccr-ssh ccr-gpg mothership thinkpad];
    "git-workspace-tokens.age".publicKeys = [ccr-ssh ccr-gpg mothership thinkpad];
    "hydra-admin-password.age".publicKeys = [ccr-ssh ccr-gpg mothership];
    "hydra-github-token.age".publicKeys = [ccr-ssh ccr-gpg mothership];
    "cache-private-key.age".publicKeys = [ccr-ssh ccr-gpg mothership];
    "autistici-password.age".publicKeys = [ccr-ssh ccr-gpg thinkpad];
    "hercules-ci-join-token.age".publicKeys = [ccr-ssh ccr-gpg mothership rock5b];
    "hercules-ci-binary-caches.age".publicKeys = [ccr-ssh ccr-gpg mothership rock5b];

    # WireGuard
    "thinkpad-wireguard-private-key.age".publicKeys = [ccr-ssh ccr-gpg thinkpad];
    "mothership-wireguard-private-key.age".publicKeys = [ccr-ssh ccr-gpg mothership];
    "rock5b-wireguard-private-key.age".publicKeys = [ccr-ssh ccr-gpg rock5b];
    "pbp-wireguard-private-key.age".publicKeys = [ccr-ssh ccr-gpg pbp];
  }
