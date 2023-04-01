let
  users.ccr = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC5cEUx25pnZiH3eBrE2xNbJ92gJiKSznDUNRzcEL4ti6FlJm+75p4q0hgdqHwStR8+uCWBL6viVFCGutOVMFE5MX1Oc3A8fJdR6H9Rrwvk/1UQzqzc9tWxw1qPLKz+fnPDomjOvNofghCWQRwX3Xf1HnIqvRwELpNbR9i+/cHkDGzLJxkstbt4gol8ywMPkw02QdKk8s5MEd1vawxc+7Chs0JPW57RDqDYFErYys52JLeAViCBB9bofF+KT42LuRXKSjWlvCV9kR5TL49vUeBgzMQWMh++WQdN4m9lpqFqYyc75I49/E0HGf8LChDSS+hvRnb5MbtnVGjEA4WDHyldmJCvUNob5CUo4FjoSPRi+S/J3Ads8D4JVwaJOJEVqmMKEhiQ0Hzk4hwe3eV/VumlZj4U/QjaCrqqi4TW/iP0gNRfzcfiM+G/z5R7w1NMUpTX7oilyKjMQmGnXB857D3SSptS7dwh5OiKhVmrQMRCduooUsj236abqLU28K//RnxhOgh8kDGgoUHApnTiMZNKhgLiR42lKrubNcW1tAAqoNyFLMwwXeMLjh0iP1b5y8ntfNPNIcGb7vcwpS24z/aIjW7rQ4J7x5EBphHGhys6ne+irdhOM8c7kFr+c8+Q2oU0YAtFuMYztAFOHm1e20X00Zvys2nuee+hT9F1NungAQ==";
  hosts = {
    test = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHc46mGCuaKLwNzK/abuedYQLw9h/Cp5MhVb7IHTGh0E root@test";
    thinkpad = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDZMyLFfuBeDfPLn8WL6JazYpYq3oVvCdD4ktyt915TL";
    mothership = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFlepPWHE9GvQIBcAQBQPd80oiePSPxGDnMdqpdEqx6I";
  };
in {
  "cachix.age".publicKeys = [users.ccr hosts.mothership];
  "autistici-password.age".publicKeys = [users.ccr];
  "magit-forge-github-token.age".publicKeys = [users.ccr hosts.mothership];
  "git-workspace-tokens.age".publicKeys = [users.ccr hosts.test hosts.mothership];

  # WireGuard

  "thinkpad-wireguard-private-key.age".publicKeys = [hosts.thinkpad];
}
