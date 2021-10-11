(add-to-list 'load-path "~/.emacs.d/config")

(setq gc-cons-threshold 100000000
      read-process-output-max (* 1024 1024))

(require 'aesthetics)
(require 'config-emacs)
(require 'config-evil)
(require 'config-helm)
(require 'config-org)
(require 'config-projectile)
(require 'config-company)
(require 'config-magit)
(require 'config-treemacs)
(require 'config-lsp)
(require 'config-python)
(require 'nix)
