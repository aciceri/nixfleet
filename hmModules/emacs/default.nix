{
  pkgs,
  config,
  lib,
  ...
}: let
  rev = "2ddc480f4417775d6bf8ebcfc27b8cd7fa761a7d"; # Emacs 29, seems a good commit
  sha256 = "sha256-SmtafhTYOI27/eraeaXwC1F09K+WNpjOy5WFu1h4QQg=";
  emacsMaster =
    (pkgs.emacs.override {
      nativeComp = true;
      withPgtk = true;
      withSQLite3 = true;
      withGTK3 = true;
    })
    .overrideAttrs (old: {
      src = pkgs.fetchFromSavannah {
        repo = "emacs";
        inherit rev sha256;
      };
      version = rev;
      patches = [];
      postPatch =
        old.postPatch
        + ''
          substituteInPlace lisp/loadup.el \
          --replace '(emacs-repository-get-version)' '"${rev}"' \
          --replace '(emacs-repository-get-branch)' '"master"'
        ''
        + (lib.optionalString (old ? NATIVE_FULL_AOT)
          # TODO: remove when https://github.com/NixOS/nixpkgs/pull/193621 is merged
          (
            let
              backendPath =
                lib.concatStringsSep " "
                (builtins.map (x: ''\"-B${x}\"'') [
                  # Paths necessary so the JIT compiler finds its libraries:
                  "${lib.getLib pkgs.libgccjit}/lib"
                  "${lib.getLib pkgs.libgccjit}/lib/gcc"
                  "${lib.getLib pkgs.stdenv.cc.libc}/lib"

                  # Executable paths necessary for compilation (ld, as):
                  "${lib.getBin pkgs.stdenv.cc.cc}/bin"
                  "${lib.getBin pkgs.stdenv.cc.bintools}/bin"
                  "${lib.getBin pkgs.stdenv.cc.bintools.bintools}/bin"
                ]);
            in ''
              substituteInPlace lisp/emacs-lisp/comp.el --replace \
                "(defcustom comp-libgccjit-reproducer nil" \
                "(setq native-comp-driver-options '(${backendPath})) (defcustom comp-libgccjit-reproducer nil"
            ''
          ));
    });
in {
  programs.emacs = {
    enable = true;
  };

  programs.doom-emacs = {
    enable = true;
    emacsPackage = emacsMaster;
    doomPrivateDir = ../../doom.d;
    doomPackageDir = pkgs.linkFarm "my-doom-packages" [
      {
        name = "config.el";
        path = pkgs.emptyFile;
      }
      {
        name = "init.el";
        path = ../../doom.d/init.el;
      }
      {
        name = "packages.el";
        path = ../../doom.d/packages.el;
      }
      {
        name = "modules";
        path = ../../doom.d/modules;
      }
    ];
    extraPackages = with pkgs; [mu];
  };

  services.emacs = {
    enable = true;
    defaultEditor = true;
  };

  home.packages = with pkgs; let
    path = pkgs.lib.makeBinPath [
      git
      jq
      nix
      nixpkgs-fmt
    ];
    nixFormat = writeScriptBin "nixFormat" ''
      export PATH=${pkgs.lib.escapeShellArg path}

      customFormatter=$(nix flake show --no-write-lock-file --no-update-lock-file --json | jq 'has("formatter")')

      if [[ $customFormatter == "true" ]]
      then
        nix fmt <<< /dev/stdin
      else
        nixpkgs-fmt <<< /dev/stdin
      fi
    '';
  in
    [
      binutils
      (ripgrep.override {withPCRE2 = true;})
      gnutls
      fd
      imagemagick
      sqlite
      maim
      nil
      nixFormat
      jq
      xclip
      hunspell
    ]
    ++ (with hunspellDicts; [
      en_US-large
      it_IT
    ]);
}
