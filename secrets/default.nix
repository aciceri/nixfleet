let
  keys = (import ../lib).keys;
in
  with keys.hosts;
  with keys.users; {
    "cachix-personal-token.age".publicKeys = [ccr-ssh ccr-gpg mothership kirk sisko pbp picard];
    "magit-forge-github-token.age".publicKeys = [ccr-ssh ccr-gpg mothership kirk];
    "git-workspace-tokens.age".publicKeys = [ccr-ssh ccr-gpg mothership kirk picard];
    "hydra-admin-password.age".publicKeys = [ccr-ssh ccr-gpg mothership];
    "hydra-github-token.age".publicKeys = [ccr-ssh ccr-gpg mothership];
    "cache-private-key.age".publicKeys = [ccr-ssh ccr-gpg mothership];
    "autistici-password.age".publicKeys = [ccr-ssh ccr-gpg kirk picard];
    "hercules-ci-join-token.age".publicKeys = [ccr-ssh ccr-gpg mothership sisko picard];
    "hercules-ci-binary-caches.age".publicKeys = [ccr-ssh ccr-gpg mothership sisko picard];
    "hercules-ci-secrets-json.age".publicKeys = [ccr-ssh ccr-gpg mothership sisko picard];
    "minio-credentials.age".publicKeys = [ccr-ssh ccr-gpg mothership];
    "aws-credentials.age".publicKeys = [ccr-ssh ccr-gpg mothership sisko];
    "nextcloud-admin-pass.age".publicKeys = [ccr-ssh ccr-gpg sisko];
    "home-planimetry.age".publicKeys = [ccr-ssh ccr-gpg sisko];
    "chatgpt-token.age".publicKeys = [ccr-ssh ccr-gpg kirk mothership picard];
    "cloudflare-dyndns-api-token.age".publicKeys = [ccr-ssh ccr-gpg sisko];
    "restic-hetzner-password.age".publicKeys = [ccr-ssh ccr-gpg picard sisko];

    # WireGuard
    "picard-wireguard-private-key.age".publicKeys = [ccr-ssh ccr-gpg picard];
    "sisko-wireguard-private-key.age".publicKeys = [ccr-ssh ccr-gpg sisko];
    "kirk-wireguard-private-key.age".publicKeys = [ccr-ssh ccr-gpg kirk];
  }
