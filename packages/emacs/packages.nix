pkgs: epkgs:
let
  inherit (epkgs) melpaPackages nongnuPackages elpaPackages;

  buildEmacsPackage =
    args:
    epkgs.trivialBuild {
      pname = args.name;
      inherit (args) src;
      version = args.src.rev;
      propagatedUserEnvPkgs = args.deps;
      buildInputs = args.deps;
      postInstall = args.postInstall or "";
    };

  # *Attrset* containig extra emacs packages
  extraPackages = {
    combobulate = buildEmacsPackage {
      name = "combobulate";
      src = pkgs.fetchFromGitHub {
        owner = "mickeynp";
        repo = "combobulate";
        rev = "e9c5be84062e8183f556d7133d5a477a57e37e51";
        hash = "sha256-r6jObsYx7RRTJUmrCN5h3+0WcHqJA67emhr4/W3rBrM=";
      };
      deps = [ ];
    };
    gptscript = buildEmacsPackage {
      name = "gptscript";
      src = pkgs.fetchFromGitHub {
        owner = "emacs-openai";
        repo = "gptscript-mode";
        rev = "d9c6272de1288d3f42a1cbac136e5fac57e185e2";
        hash = "sha256-RM0dptx8qm2b4fvW6oQ0Lq5kshRKcapeIW2piUMAZmw=";
      };
      deps = [ ];
    };
    p-search = buildEmacsPackage {
      name = "p-search";
      src = pkgs.fetchFromGitHub {
        owner = "zkry";
        repo = "p-search";
        rev = "3fcf06f862976433642d07d06ec911efc43d0189";
        hash = "sha256-j4JEV+uHXK5Uf6/7D2AaSMKxBr3t59U+WNZzVsJ+gkc=";
      };
      deps = [ elpaPackages.heap ];
    };
    copilot = buildEmacsPackage {
      name = "copilot";
      src = pkgs.fetchFromGitHub {
        owner = "copilot-emacs";
        repo = "copilot.el";
        rev = "b7bff7b934837744688fd74191ecffb83b3bcc05";
        hash = "sha256-MEsjXQIeiTI6NXN5rTW7HfFPC18IZnhAssma2BZa0ks=";
      };
      deps = with epkgs; [
        s
        dash
        editorconfig
        jsonrpc
        f
      ];
    };
    lean4-mode = buildEmacsPackage {
      name = "lean4-mode";
      src = pkgs.fetchFromGitHub {
        owner = "leanprover-community";
        repo = "lean4-mode";
        rev = "76895d8939111654a472cfc617cfd43fbf5f1eb6";
        hash = "sha256-DLgdxd0m3SmJ9heJ/pe5k8bZCfvWdaKAF0BDYEkwlMQ=";
      };
      deps = [
        epkgs.dash
        melpaPackages.magit
        melpaPackages.lsp-mode
      ];
      postInstall = ''
        cp -r $src/data $LISPDIR
      '';
    };
    kdl-ts-mode = buildEmacsPackage {
      name = "kdl-ts-mode";
      src = pkgs.fetchFromGitHub {
        owner = "dataphract";
        repo = "kdl-ts-mode";
        rev = "3dbf116cd19261d8d70f456ae3385e1d20208452";
        hash = "sha256-4bfKUzzLhBFg4TeGQD0dClumcO4caIBU8/uRncFVVFQ=";
      };
      deps = [ ];
    };
    ultra-scroll = buildEmacsPackage {
      name = "ultra-scroll";
      src = pkgs.fetchFromGitHub {
        owner = "jdtsmith";
        repo = "ultra-scroll";
        rev = "78ab497c6568e4a99f34a84b4c9bfe87d1a71d8c";
        hash = "sha256-q/LGP69GRtEEbSpXi9JUoZjr/UV1QMVjQw96M6qxsZU=";
      };
      deps = [ ];
    };
    eglot-booster = buildEmacsPackage {
      name = "eglot-booster";
      src = pkgs.fetchFromGitHub {
        owner = "jdtsmith";
        repo = "eglot-booster";
        rev = "e6daa6bcaf4aceee29c8a5a949b43eb1b89900ed";
        hash = "sha256-PLfaXELkdX5NZcSmR1s/kgmU16ODF8bn56nfTh9g6bs=";
      };
      deps = [ ];
    };
    aiken-mode = buildEmacsPackage {
      name = "aiken-mode";
      src = pkgs.fetchFromGitHub {
        owner = "xxAVOGADROxx";
        repo = "aiken-mode";
        rev = "2772ef1c9b08ab8d8cb8480ccecc7ba03eacb3cc";
        hash = "sha256-Hi4iDq75CsAp+MJaCOhNnym3gPUwykqI28lID8WVsW8=";
      };
      deps = [ ];
    };
  };

  # *List* containing emacs packages from (M)ELPA
  mainPackages =
    builtins.filter
      # if an extra package has the same name then give precedence to it
      (package: !builtins.elem package.pname (builtins.attrNames extraPackages))
      (
        with melpaPackages;
        [
          meow
          meow-tree-sitter
          dracula-theme
          nord-theme
          catppuccin-theme
          modus-themes
          # solaire-mode
          nerd-icons
          nerd-icons-completion
          nerd-icons-ibuffer
          nerd-icons-dired
          ligature
          treemacs-nerd-icons
          eshell-syntax-highlighting
          eshell-prompt-extras
          eshell-atuin
          eshell-command-not-found
          clipetty
          sideline
          consult-eglot
          # sideline-flymake
          rainbow-delimiters
          vertico
          marginalia
          consult
          orderless
          embark
          embark-consult
          magit
          (magit-delta.override (old: {
            # FIXME why is this needed?
            melpaBuild =
              args:
              old.melpaBuild (
                args
                // {
                  packageRequires = (args.packageRequires or [ ]) ++ [ dash ];
                }
              );
          }))
          magit-todos
          difftastic
          with-editor
          diff-hl
          corfu
          cape
          which-key
          nix-mode
          nix-ts-mode
          agenix
          zig-mode
          unisonlang-mode
          purescript-mode
          dhall-mode
          envrc
          inheritenv
          popper
          paredit
          yaml-mode
          hl-todo
          markdown-mode
          haskell-mode
          terraform-mode
          rust-mode
          diredfl
          org-modern
          math-preview
          org-roam
          org-roam-ql
          org-roam-ui
          org-download
          visual-fill-column
          consult-org-roam
          pass
          password-store-otp
          eldoc-box
          # go-translate
          notmuch
          consult-notmuch
          poly-org
          casual
          gptel
          agenix
          solidity-mode
          telega
          aggressive-indent
          mixed-pitch
          visual-replace
          org-super-agenda
          tidal
          aidermacs
          noir-ts-mode
          # org-re-reveal # FIXME very not nice hash mismatch when building
        ]
      )
    ++ (with elpaPackages; [
      delight
      kind-icon
      ef-themes
      indent-bars
      ement
      vundo
      pulsar
    ])
    ++ (with nongnuPackages; [
      eat
      corfu-terminal
      haskell-ts-mode
    ])
    ++ (with epkgs; [
      typst-ts-mode # why this doesn't seem to be in elpaPackages?
    ]);
in
mainPackages ++ (builtins.attrValues extraPackages)
