{pkgs, ...}: {
  environment.systemPackages = [
    pkgs.vim
  ];

  nix.settings.experimental-features = "nix-command flakes";

  programs.fish.enable = true;

  services.nix-daemon.enable = true;

  nixpkgs.localSystem = "x86_64-darwin";
}
