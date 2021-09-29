(add-to-list 'load-path "~/.emacs.d/config")

(setq gc-cons-threshold 100000000
      read-process-output-max (* 1024 1024)
)

(require 'aesthetics)
(require 'config-evil)
(require 'lsp)
(require 'nix)