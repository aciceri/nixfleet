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
          fish-completion # fish completion for eshell
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
          magit-delta
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
          diredfl
          org-modern
          org-roam
          org-roam-ql
          org-roam-ui
          visual-fill-column
          consult-org-roam
          pass
          password-store-otp
          eldoc-box
          go-translate
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
    ]);
in
mainPackages ++ (builtins.attrValues extraPackages)
