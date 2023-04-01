let
  users = {
    ccr-gpg = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC5cEUx25pnZiH3eBrE2xNbJ92gJiKSznDUNRzcEL4ti6FlJm+75p4q0hgdqHwStR8+uCWBL6viVFCGutOVMFE5MX1Oc3A8fJdR6H9Rrwvk/1UQzqzc9tWxw1qPLKz+fnPDomjOvNofghCWQRwX3Xf1HnIqvRwELpNbR9i+/cHkDGzLJxkstbt4gol8ywMPkw02QdKk8s5MEd1vawxc+7Chs0JPW57RDqDYFErYys52JLeAViCBB9bofF+KT42LuRXKSjWlvCV9kR5TL49vUeBgzMQWMh++WQdN4m9lpqFqYyc75I49/E0HGf8LChDSS+hvRnb5MbtnVGjEA4WDHyldmJCvUNob5CUo4FjoSPRi+S/J3Ads8D4JVwaJOJEVqmMKEhiQ0Hzk4hwe3eV/VumlZj4U/QjaCrqqi4TW/iP0gNRfzcfiM+G/z5R7w1NMUpTX7oilyKjMQmGnXB857D3SSptS7dwh5OiKhVmrQMRCduooUsj236abqLU28K//RnxhOgh8kDGgoUHApnTiMZNKhgLiR42lKrubNcW1tAAqoNyFLMwwXeMLjh0iP1b5y8ntfNPNIcGb7vcwpS24z/aIjW7rQ4J7x5EBphHGhys6ne+irdhOM8c7kFr+c8+Q2oU0YAtFuMYztAFOHm1e20X00Zvys2nuee+hT9F1NungAQ== andrea.ciceri@autistici.org";
    ccr-ssh = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCzCmDCtlGscpesHuoiruVWD2IjYEFtaIl9Y2JZGiOAyf3V17KPx0MikcknfmxSHi399SxppiaXQHxo/1wjGxXkXNTTv6h1fBuqwhJE6C8+ZSV+gal81vEnXX+/9w2FQqtVgnG2/mO7oJ0e3FY+6kFpOsGEhYexoGt/UxIpAZoqIN+CWNhJIASUkneaZWtgwiL8Afb59kJQ2E7WbBu+PjYZ/s5lhPobhlkz6s8rkhItvYdiSHT0DPDKvp1oEbxsxd4E4cjJFbahyS8b089NJd9gF5gs0b74H/2lUUymnl63cV37Mp4iXB4rtE69MbjqsGEBKTPumLualmc8pOGBHqWIdhAqGdZQeBajcb6VK0E3hcU0wBB+GJgm7KUzlAHGdC3azY0KlHMrLaZN0pBrgCVR6zBNWtZz2B2qMBZ8Cw+K4vut8GuspdXZscID10U578GxQvJAB9CdxNUtrzSmKX2UtZPB1udWjjIAlejzba4MG73uXgQEdv0NcuHNwaLuCWxTUT5QQF18IwlJ23Mg8aPK8ojUW5A+kGHAu9wtgZVcX1nS5cmYKSgLzcP1LA1l9fTJ1vqBSuy38GTdUzfzz7AbnkRfGPj2ALDgyx17Rc5ommjc1k0gFoeIqiLaxEs5FzDcRyo7YvZXPsGeIqNCYwQWw3+U+yUEJby8bxGb2d/6YQ== andrea.ciceri@autistici.org";
  };
  hosts = {
    thinkpad = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDZMyLFfuBeDfPLn8WL6JazYpYq3oVvCdD4ktyt915TL";
    mothership = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFlepPWHE9GvQIBcAQBQPd80oiePSPxGDnMdqpdEqx6I";
  };
in
  with hosts;
  with users; {
    "cachix-personal-token.age".publicKeys = [ccr-ssh ccr-gpg mothership thinkpad];
    "magit-forge-github-token.age".publicKeys = [ccr-ssh ccr-gpg mothership thinkpad];
    "git-workspace-tokens.age".publicKeys = [ccr-ssh ccr-gpg mothership thinkpad];

    # WireGuard
    "thinkpad-wireguard-private-key.age".publicKeys = [ccr-ssh ccr-gpg hosts.thinkpad];
    "mothership-wireguard-private-key.age".publicKeys = [ccr-ssh ccr-gpg hosts.mothership];
  }
