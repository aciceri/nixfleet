{ pkgs, ... }:
# recommend using `hashedPassword`
{
  users.users.root = {
    password = "nixos";
    shell = pkgs.zsh;
  };
}
