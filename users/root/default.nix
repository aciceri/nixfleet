{ pkgs, ... }:
# recommend using `hashedPassword`
{
  users.users.root = {
    password = "nixos";
    shell = pkgs.zsh;
  };

  # FIXME: (temporary?) workaround for https://github.com/NixOS/nixpkgs/issues/169193
  home-manager.users.ccr.programs.git = {
    enable = true;
    extraConfig.safe.directory = "/home/ccr/fleet";
  };
  home-manager.users.root.programs.git = {
    enable = true;
    extraConfig.safe.directory = "/home/ccr/fleet";
  };

}
