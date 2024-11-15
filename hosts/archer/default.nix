{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    helix
    vim
    git
  ];

  nix.settings.experimental-features = "nix-command flakes";

  programs.fish.enable = true;

  services.nix-daemon.enable = true;

  system.stateVersion = 5;
}
