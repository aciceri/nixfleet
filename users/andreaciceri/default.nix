{ config, lib, pkgs, ... }: {
  home-manager.users."andreaciceri" = {...}: {
    imports = [
      ../profiles/bat
      ../profiles/fzf
      ../profiles/zsh
      ../profiles/direnv
      ../profiles/exa
    ];
    home.packages = with pkgs; [
      yarn
    ];
  };

}
