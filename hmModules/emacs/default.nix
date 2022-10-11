{
  pkgs,
  config,
  ...
}: {
  programs.emacs.enable = true;

  programs.doom-emacs = {
    enable = true;
    package = pkgs.emacs28NativeComp;
    doomPrivateDir = ../../doom.d;
  };

  services.emacs = {
    enable = true;
    defaultEditor = true;
  };

  home.packages = with pkgs; let
    path = pkgs.lib.makeBinPath (with pkgs; [
      nix
      nixpkgs-fmt
      git
    ]);
    nixFormat = writeScriptBin "nixFormat" ''
      export PATH=${pkgs.lib.escapeShellArg path}

      if [[ ! "$(nix fmt $@)" ]]
      then
        nixpkgs-fmt $@
      fi
    '';
  in [
    binutils
    (ripgrep.override {withPCRE2 = true;})
    gnutls
    fd
    imagemagick
    sqlite
    maim
    nixFormat
    jq
    xclip
  ];
}
