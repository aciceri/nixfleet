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
    "autistici-password.age".publicKeys = [ccr-ssh ccr-gpg kirk picard sisko];
    "hercules-ci-join-token.age".publicKeys = [ccr-ssh ccr-gpg mothership sisko picard];
    "hercules-ci-binary-caches.age".publicKeys = [ccr-ssh ccr-gpg mothership sisko picard];
    "hercules-ci-secrets-json.age".publicKeys = [ccr-ssh ccr-gpg mothership sisko picard];
    "minio-credentials.age".publicKeys = [ccr-ssh ccr-gpg picard sisko];
    "aws-credentials.age".publicKeys = [ccr-ssh ccr-gpg picard sisko];
    "nextcloud-admin-pass.age".publicKeys = [ccr-ssh ccr-gpg sisko];
    "home-planimetry.age".publicKeys = [ccr-ssh ccr-gpg sisko];
    "home-assistant-token.age".publicKeys = [ccr-ssh ccr-gpg sisko];
    "chatgpt-token.age".publicKeys = [ccr-ssh ccr-gpg kirk mothership picard deltaflyer];
    "cloudflare-dyndns-api-token.age".publicKeys = [ccr-ssh ccr-gpg sisko];
    "restic-hetzner-password.age".publicKeys = [ccr-ssh ccr-gpg picard sisko kirk];
    "hass-ssh-key.age".publicKeys = [ccr-ssh ccr-gpg sisko];
    "grafana-password.age".publicKeys = [ccr-ssh ccr-gpg sisko];
    "matrix-registration-shared-secret.age".publicKeys = [ccr-ssh ccr-gpg sisko];
    "matrix-sliding-sync-secret.age".publicKeys = [ccr-ssh ccr-gpg sisko];
    "forgejo-runners-token.age".publicKeys = [ccr-ssh ccr-gpg picard];
    "forgejo-nix-access-tokens.age".publicKeys = [ccr-ssh ccr-gpg picard];

    # WireGuard
    "picard-wireguard-private-key.age".publicKeys = [ccr-ssh ccr-gpg picard];
    "sisko-wireguard-private-key.age".publicKeys = [ccr-ssh ccr-gpg sisko];
    "kirk-wireguard-private-key.age".publicKeys = [ccr-ssh ccr-gpg kirk];
    "deltaflyer-wireguard-private-key.age".publicKeys = [ccr-ssh ccr-gpg deltaflyer];
  }
