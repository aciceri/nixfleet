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

    # WireGuard
    "thinkpad-wireguard-private-key.age".publicKeys = [ccr-ssh ccr-gpg thinkpad];
    "mothership-wireguard-private-key.age".publicKeys = [ccr-ssh ccr-gpg mothership];
  }
