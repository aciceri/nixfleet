{
  pkgs,
  config,
  lib,
  ...
}: {
  programs.emacs = {
    enable = true;
    package = lib.mkForce (pkgs.emacs28NativeComp.override {
      # FIXME `mkForce` shouldn't be needed
      nativeComp = true;
      withSQLite3 = true;
      withGTK3 = true;
    });
  };

  programs.doom-emacs = {
    enable = true;
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
