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
      openscad
      nodejs-14_x

      poetry
      ipfs
      ipget

      yabai
      skhd
      spacebar
      xquartz
      xterm

      qmk

      youtube-dl
      ffmpeg
    ];

    programs.gpg = {
      homedir = "/Users/andreaciceri/.gnupg";
      enable = true;
    };
  };
}
