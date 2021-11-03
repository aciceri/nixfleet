{ config, lib, pkgs, emacs-overlay, ... }: {
  home-manager.users."andreaciceri" = { ... }: {
    imports = [
      ../profiles/bat
      ../profiles/fzf
      ../profiles/zsh
      ../profiles/git
      ../profiles/direnv
      ../profiles/exa
      ../profiles/emacs
    ];
    home.packages = with pkgs; [
      yarn
      pinentry_mac
    ];

    programs.gpg = {
      homedir = "/Users/andreaciceri/.gnupg";
      enable = true;
    };
  };
}
