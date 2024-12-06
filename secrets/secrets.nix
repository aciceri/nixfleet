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
  "chatgpt-token.age".publicKeys = [
    ccr-ssh

    kirk
    mothership
    picard
    deltaflyer
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
  ];
  "forgejo-nix-access-tokens.age".publicKeys = [
    ccr-ssh

    picard
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
}
