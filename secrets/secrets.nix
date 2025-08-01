let
  keys = (import ../lib).keys;
in
with keys.hosts;
with keys.users;
{
  "cachix-personal-token.age".publicKeys = [
    ccr-ssh
    mothership
    kirk
    sisko
    pbp
    picard
    pike
  ];
  "magit-forge-github-token.age".publicKeys = [
    ccr-ssh
    mothership
    kirk
  ];
  "git-workspace-tokens.age".publicKeys = [
    ccr-ssh
    mothership
    kirk
    picard
    pike
  ];
  "hydra-admin-password.age".publicKeys = [
    ccr-ssh
    mothership
  ];
  "hydra-github-token.age".publicKeys = [
    ccr-ssh
    mothership
  ];
  "cache-private-key.age".publicKeys = [
    ccr-ssh
    mothership
  ];
  "autistici-password.age".publicKeys = [
    ccr-ssh
    kirk
    picard
    sisko
    pike
  ];
  "hercules-ci-join-token.age".publicKeys = [
    ccr-ssh
    mothership
    sisko
    picard
  ];
  "hercules-ci-binary-caches.age".publicKeys = [
    ccr-ssh
    mothership
    sisko
    picard
  ];
  "hercules-ci-secrets-json.age".publicKeys = [
    ccr-ssh
    mothership
    sisko
    picard
  ];
  "minio-credentials.age".publicKeys = [
    ccr-ssh
    picard
    sisko
  ];
  "aws-credentials.age".publicKeys = [
    ccr-ssh
    picard
    sisko
  ];
  "nextcloud-admin-pass.age".publicKeys = [
    ccr-ssh
    sisko
  ];
  "home-planimetry.age".publicKeys = [
    ccr-ssh
    sisko
  ];
  "home-assistant-token.age".publicKeys = [
    ccr-ssh
    sisko
  ];
  "openrouter-api-key.age".publicKeys = [
    ccr-ssh
    kirk
    mothership
    picard
    deltaflyer
    pike
  ];
  "cloudflare-api-tokens.age".publicKeys = [
    ccr-ssh
    sisko
  ];
  "cloudflare-dyndns-api-token.age".publicKeys = [
    ccr-ssh
    sisko
  ];
  "restic-hetzner-password.age".publicKeys = [
    ccr-ssh
    picard
    sisko
    kirk
    pike
  ];
  "hass-ssh-key.age".publicKeys = [
    ccr-ssh
    sisko
  ];
  "grafana-password.age".publicKeys = [
    ccr-ssh
    sisko
  ];
  "matrix-registration-shared-secret.age".publicKeys = [
    ccr-ssh
    sisko
  ];
  "matrix-sliding-sync-secret.age".publicKeys = [
    ccr-ssh
    sisko
  ];
  "forgejo-runners-token.age".publicKeys = [
    ccr-ssh
    picard
    pike
  ];
  "forgejo-nix-access-tokens.age".publicKeys = [
    ccr-ssh
    picard
    pike
  ];
  "garmin-collector-environment.age".publicKeys = [
    ccr-ssh
    sisko
  ];
  "hetzner-storage-box-sisko-ssh-password.age".publicKeys = [
    ccr-ssh
    sisko
  ];
  "sisko-restic-password.age".publicKeys = [
    ccr-ssh
    sisko
  ];
  "sisko-attic-environment-file.age".publicKeys = [
    ccr-ssh
    sisko
  ];
  "firefly-app-key.age".publicKeys = [
    ccr-ssh
    sisko
  ];
  "arbi-config.age".publicKeys = [
    ccr-ssh
    sisko
  ];
  "nix-netrc.age".publicKeys = [
    ccr-ssh
    sisko
    pike
    picard
    kirk
  ];
  "wireguard-mlabs-private-key.age".publicKeys = [
    ccr-ssh
    picard
    pike
    kirk
  ];

  # WireGuard
  "picard-wireguard-private-key.age".publicKeys = [
    ccr-ssh
    picard
  ];
  "sisko-wireguard-private-key.age".publicKeys = [
    ccr-ssh
    sisko
  ];
  "kirk-wireguard-private-key.age".publicKeys = [
    ccr-ssh
    kirk
  ];
  "deltaflyer-wireguard-private-key.age".publicKeys = [
    ccr-ssh
    deltaflyer
  ];
  "tpol-wireguard-private-key.age".publicKeys = [
    ccr-ssh
    tpol
  ];
  "pike-wireguard-private-key.age".publicKeys = [
    ccr-ssh
    pike
  ];
}
