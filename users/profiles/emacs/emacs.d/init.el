(add-to-list 'load-path "~/.emacs.d/config")

(setq gc-cons-threshold 100000000
      read-process-output-max (* 1024 1024))

(defun executable-find (command) ;; to move
  "Search for COMMAND in `exec-path' and return the absolute file name.
Return nil if COMMAND is not found anywhere in `exec-path'."
  ;; Use 1 rather than file-executable-p to better match the behavior of
  ;; call-process.
  (locate-file command exec-path exec-suffixes 1))


(require 'aesthetics)
(require 'config-emacs)
(require 'config-evil)
(require 'config-helm)
(require 'config-org)
(require 'config-emails)
(require 'config-projectile)
(require 'config-company)
(require 'config-magit)
(require 'config-treemacs)
(require 'config-lsp)
(require 'config-python)
(require 'config-spelling)
(require 'config-nix)
(require 'config-purescript)

(server-start)
